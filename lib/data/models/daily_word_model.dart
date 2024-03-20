import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String id;
  final String audio;
  final String meaning;
  final String example;
  final String partOfSpeech;
  final String word;
  final String phonetic;

  const WordModel(
      {required this.id,
      required this.audio,
      required this.meaning,
      required this.example,
      required this.partOfSpeech,
      required this.word,
      required this.phonetic});

  static WordModel fromMap(Map<String, dynamic> data) {
    return WordModel(
      id: data["id"] ?? "",
      audio: data["audio"] ?? "",
      meaning: data["meaning"] ?? "",
      example: data["example"] ?? "",
      partOfSpeech: data["partofspeech"] ?? "",
      word: data["word"] ?? "",
      phonetic: data["phonetic"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "audio": audio,
      "meaning": meaning,
      "example": example,
      "partofspeech": partOfSpeech,
      "word": word,
      "phonetic": phonetic
    };
  }

  WordModel cloneWith({
    id,
    audio,
    meaning,
    example,
    partOfSpeech,
    word,
    phonetic,
  }) {
    return WordModel(
        id: id ?? this.id,
        audio: audio ?? this.audio,
        meaning: meaning ?? this.meaning,
        example: example ?? this.example,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        word: word ?? this.word,
        phonetic: phonetic ?? this.phonetic);
  }

  @override
  String toString() {
    return word;
  }

  @override
  List<Object?> get props => [id];
}
