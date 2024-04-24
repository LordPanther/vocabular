import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/models/error_model.dart';
import 'package:vocab_app/data/request/api_url.dart';
import 'package:vocab_app/data/request/request.dart';

class LocationRepository {
  final Request _request = Request(baseUrl: WordApi.BASE_URL);

  Future<WordModel> fetchWord(String word) async {
    String url = "/$word";
    var result = await _request.requestApi(method: MethodType.GET, url: url);

    if (result is ErrorModel) return word as WordModel;

    var data = (result as Map<String, dynamic>);
    WordModel wordModel = WordModel.fromMap(data);
    return wordModel;
  }
}
