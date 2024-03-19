
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/data/models/word_api_model.dart';

abstract class WordRepository {
  //Load current word to environment

  Future<DailyWordModel> fetchDailyWord();

  Future<void> addNewDailyWord(UserModel user, DailyWordModel word);

  Future<void> getWordFromApi(WordApiModel word);

}
