import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocab_app/data/models/word_model.dart';

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

  Future<List<WordModel>> getWordSwipeWords() async {
    GenerativeModel aiModel = GenerativeModel(model: model, apiKey: apiKey);
    List<WordModel> words = [];

    await Future.delayed(const Duration(seconds: 1));

    final content = [
      Content.text(
          "Generate 5 randoms words and their short definitions, separated by a semicolon")
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
      var aa = response.text!.trim().split("\n");
      for (var bb in aa) {
        var cc = bb.split(":");
        var word = WordModel(word: cc[0], definition: cc[1]);
        words.add(word);
      }
      return words;
    }
    return [];
  }
}
