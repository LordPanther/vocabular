// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:google_generative_ai/google_generative_ai.dart';
import '../../auth/secrets.dart';

class DevEnvironment {
  final receiveTimeout = 2 * 60 * 1000;
  final connectTimeout = 2 * 60 * 1000;
}

class AiModel {
  static String MODEL = model;
  static String API_KEY = apiKey;
  static GenerationConfig GENERATION_CONFIG = GenerationConfig(
    candidateCount: 1,
    stopSequences: ["END"],
    maxOutputTokens: 50,
    temperature: 1.0,
    topK: 16,
    topP: 0.5,
  );
  static List<SafetySetting> SAFETY_SETTINGS = [
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
  ];
}

final environment = DevEnvironment();
