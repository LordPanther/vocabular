import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/models/error_model.dart';
import 'package:vocab_app/data/request/api_url.dart';
import 'package:vocab_app/data/request/request.dart';

class APIRepository {
  final Request _request =
      Request(baseUrl: OpenAiApi.BASE_URL, apiKey: OpenAiApi.API_KEY);

  Future fetchActivityWords() async {
    String url = "/completions";
    String prompt =
        "generate 10 randon basic english words and their definitions separated by a semicolon";
    var result = await _request.requestApi(url: url, prompt: prompt);

    if (result is ErrorModel) return [];

    // var data = (result as Map<String, dynamic>);
    // WordModel wordModel = WordModel.fromMap(data);
    return result;
  }

  Future generateDefinition(String prompt) async {
    String url = "/completions";
    var result = await _request.requestApi(url: url, prompt: prompt);

    if (result is ErrorModel) return [];

    var data = (result as Map<String, dynamic>);
    WordModel wordModel = WordModel.fromMap(data);
    return wordModel;
  }
}
