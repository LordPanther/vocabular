import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Request {
  final String model;
  final String apiKey;
  final GenerationConfig generationConfig;
  final List<SafetySetting> safetySettings;

  Request({
    required this.model,
    required this.apiKey,
    required this.generationConfig,
    required this.safetySettings,
  });

  Future<String> requestApi({required List<Content> content}) async {
    GenerativeModel generativeModel =
        GenerativeModel(model: model, apiKey: apiKey);
    try {
      var response = await generativeModel.generateContent(
        content,
        generationConfig: generationConfig,
        safetySettings: safetySettings,
      );

      if (response.text != null) {
        return "${response.text!}\n";
      }
      return "";
    } on Exception catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return (error.toString());
    }
  }
}
