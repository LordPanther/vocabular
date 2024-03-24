import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/models/word_api_model.dart';

abstract class WordRepository {
  String get firestoreException;

  Future<WordModel> fetchDailyWord();

  Future<void> addNewWord(WordModel word);

  Future<void> getWordFromApi(WordApiModel word);

  Future<void> addWordToCollection(WordModel word, CollectionsModel collection);
}
