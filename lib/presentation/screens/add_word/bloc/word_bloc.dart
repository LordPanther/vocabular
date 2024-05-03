import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final HomeRepository _homeRepository = AppRepository.collectionsRepository;
  List<CollectionModel> collections = [];

  WordBloc() : super(Initial()) {
    on<AddWord>((event, emit) async {
      await _mapAddWordToMap(event, emit);
    });
    on<LoadWordScreen>((event, emit) async {
      await _mapGetCollectionsToMap(event, emit);
    });
  }

  Future<void> _mapAddWordToMap(event, Emitter<WordState> emit) async {
    WordModel word = event.word;
    CollectionModel collection = event.collection;
    bool shareWord = event.share;
    List<String> storedList = [
      collection.name,
      word.word,
      word.definition,
      word.audioUrl!
    ];
    try {
      await LocalPref.setStringList("recentWord", storedList);
      await _homeRepository.addWord(collection, word, shareWord);
      emit(WordAdded(word));
    } catch (error) {
      emit(WordAddFailure(error.toString()));
    }
  }

  Future<void> _mapGetCollectionsToMap(event, Emitter<WordState> emit) async {
    try {
      var collectionData = await _homeRepository.fetchCollections();
      collections = collectionData.collections;
      emit(Loaded(collections));
    } catch (error) {
      emit(CollectionFailure(error.toString()));
    }
  }
}
