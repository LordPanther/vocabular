import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  late GenerativeModel _aiModel;
  String model = "gemini-pro";
  String apiKey = "AIzaSyAKOloyTWbkHgSRIlQHKKynKRyOKw6PxCU";

  Future<String> getAiResponse(TextEditingController word) async {
    _aiModel = GenerativeModel(model: model, apiKey: apiKey);

    final content = [
      Content.text("Define ${word.text} in 100 characters or less")
    ];
    var response = await _aiModel.generateContent(
      content,
      generationConfig: GenerationConfig(
        candidateCount: 1,
        stopSequences: ["END"],
        maxOutputTokens: 500,
        temperature: 1.0,
        topK: 16,
        topP: 0.5,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );

    if (response.text != null) {
      return response.text!;
    }
    return "error";
  }
}
