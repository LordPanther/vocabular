import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/models/word_api_model.dart';

abstract class WordRepository {
  String get firestoreException;

  Future<WordModel> fetchDailyWord();

  Future<void> getWordFromApi(WordApiModel word);

  // Future<void> addWordToCollection(WordModel word, CollectionModel collection);
}

  // Future<void> addNewWord(WordModel word);