import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/repository.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/bloc.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final CollectionsRepository _collectionsRepository =
      AppRepository.collectionsRepository;

  WordBloc() : super(Initial()) {
    on<AddWord>((event, emit) async {
      await _mapAddWordToMap(event, emit);
    });
    on<GetCollections>((event, emit) async {
      await _mapGetCollectionsToMap(event, emit);
    });
  }

  Future<void> _mapAddWordToMap(event, Emitter<WordState> emit) async {
    WordModel word = event.word;
    CollectionModel collection = event.collection;
    bool shareWord = event.shareWord;
    try {
      await _collectionsRepository.addNewWord(
          collection, word, shareWord);
    } catch (error) {
      emit(WordAddFailure(error.toString()));
    }
  }

  Future<void> _mapGetCollectionsToMap(event, Emitter<WordState> emit) async {
    try {
      var collectionData = await _collectionsRepository.fetchCollections();
      emit(CollectionsRecieved(collectionData.collections));
    } catch (error) {
      emit(CollectionFailure(error.toString()));
    }
  }
}
