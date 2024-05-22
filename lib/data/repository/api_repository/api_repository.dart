import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocab_app/data/models/error_model.dart';
import 'package:vocab_app/data/request/api_url.dart';
import 'package:vocab_app/data/request/request.dart';

class APIRepository {
  final Request _request = Request(
    model: AiModel.MODEL,
    apiKey: AiModel.API_KEY,
    generationConfig: AiModel.GENERATION_CONFIG,
    safetySettings: AiModel.SAFETY_SETTINGS,
  );

  Future generateDefinition(String word) async {
    var content = [
      Content.text(
          "Generate a definition or explanation of the below word using basic english\nWord:$word")
    ];
    var result = await _request.requestApi(content: content);

    if (result is ErrorModel) return [];
    return result;
  }
}
