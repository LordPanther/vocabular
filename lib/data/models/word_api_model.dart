class WordApiModel {
  final String word;
  final String phonetics;
  final String audioUrl;
  final String partOfSpeech;
  final String definition;
  final String meaning;

  WordApiModel({
    required this.word,
    required this.phonetics,
    required this.audioUrl,
    required this.partOfSpeech,
    required this.definition,
    required this.meaning,
  });

  Map<String, dynamic> toMap() {
    return {
      "word": word,
      "phonetics": phonetics,
      "audioUrl": audioUrl,
      "partOfSpeech": partOfSpeech,
      "definition": definition,
      "meaning": meaning,
    };
  }

  factory WordApiModel.fromJson(Map<String, dynamic> json) {
    return WordApiModel(
      word: json['word'] ?? '',
      phonetics: json['phonetic'] ?? '',
      audioUrl: json['phonetics'][0]['audio'] ?? '',
      partOfSpeech: json['meanings'][0]['partOfSpeech'] ?? '',
      definition: json['meanings'][0]['definitions'][0]['definition'] ?? '',
      meaning: json['meanings'][0]['definitions'][0]['definition'] ?? '',
    );
  }

}
