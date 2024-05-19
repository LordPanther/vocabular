import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  String model = "gemini-pro";
  String apiKey = "AIzaSyAKOloyTWbkHgSRIlQHKKynKRyOKw6PxCU";

  Future<String> getAiResponse(TextEditingController word) async {
    GenerativeModel aiModel = GenerativeModel(model: model, apiKey: apiKey);

    await Future.delayed(const Duration(seconds: 1));

    final content = [
      Content.text("Define ${word.text} in 100 characters or less")
    ];
    var response = await aiModel.generateContent(
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
      return "${response.text!}\n";
    }
    return "error";
  }

  static final AIService _instance = AIService._internal();

  factory AIService() {
    return _instance;
  }
  AIService._internal();
}
