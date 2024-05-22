// ignore_for_file: constant_identifier_names

class DevEnvironment {
  final receiveTimeout = 2 * 60 * 1000;
  final connectTimeout = 2 * 60 * 1000;
}

class OpenAiApi {
  static String BASE_URL = "https://api.openai.com/v1";
  static String API_KEY =
      "sk-proj-dEshB6kmCLKJwOuxu5rsT3BlbkFJbuiOu7B2rOViB4fiOIST";
}

class Propmts {
  static String activityWords = "https://api.openai.com/v1";
  static String word =
      "";
}

final environment = DevEnvironment();

enum MethodType { GET, POST }
