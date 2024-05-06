import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final HomeRepository _homeRepository = AppRepository.collectionsRepository;
  final AuthRepository _authRepository = AppRepository.authRepository;
  User get user => _authRepository.loggedFirebaseUser;
  List<CollectionModel> collections = [];

  WordBloc() : super(Initial()) {
    on<AddWord>((event, emit) async {
      await _mapAddWordToMap(event, emit);
    });
    on<LoadWordScreen>((event, emit) async {
      await _mapGetCollectionsToMap(event, emit);
    });
  }

  List<String> recentWord(AddWordModel word) {
    return [
      word.collection.name!,
      word.word.word!,
      word.word.definition!,
      word.word.audioUrl!
    ];
  }

  

  Future<void> _mapAddWordToMap(event, Emitter<WordState> emit) async {
    AddWordModel word = event.word;

    List<String> storedList = recentWord(word);
    
    try {
      await LocalPref.setStringList("recentWord", storedList);
      await _homeRepository.addWord(word.word);
      emit(WordAdded(word));
    } catch (error) {
      emit(WordAddFailure(error.toString()));
    }
  }

  Future<void> _mapGetCollectionsToMap(event, Emitter<WordState> emit) async {
    try {
      var collectionData = await _homeRepository.fetchCollections();
      collections = collectionData.collections;
      emit(Loaded(collections, user));
    } catch (error) {
      emit(CollectionFailure(error.toString()));
    }
  }
}
