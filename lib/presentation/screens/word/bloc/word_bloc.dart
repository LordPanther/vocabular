import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/word/bloc/bloc.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final HomeRepository _homeRepository = AppRepository.collectionsRepository;
  final AuthRepository _authRepository = AppRepository.authRepository;
  User get user => _authRepository.currentUser;
  List<CollectionModel> collections = [];

  WordBloc() : super(Initial()) {
    on<AddWord>((event, emit) async {
      await _mapAddWordToMap(event, emit);
    });
    on<UpdateWord>((event, emit) async {
      await _mapUpdateWordToMap(event, emit);
    });
    on<LoadWordScreen>((event, emit) async {
      await _mapGetCollectionsToMap(event, emit);
    });
  }

  Future<void> _mapUpdateWordToMap(event, Emitter<WordState> emit) async {
    WordModel oldWord = event.oldWord;
    AddWordModel updatedWord = event.updatedWord;

    try {
      emit(UpdatingWord());
      await _homeRepository.updateHomeData(updatedWord, oldWord);
      emit(WordAdded(updatedWord));
    } on Exception catch (error) {
      emit(WordAddFailure(error.toString()));
    }
  }

  Future<void> _mapAddWordToMap(event, Emitter<WordState> emit) async {
    AddWordModel data = event.word;

    try {
      emit(AddingWord());
      await _homeRepository.addWord(data.word);
      emit(WordAdded(data));
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
