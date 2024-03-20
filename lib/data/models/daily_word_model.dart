import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String id;
  final String audio;
  final String definition;
  final String acronym;
  final String partOfSpeech;
  final String note;
  final String word;

  const WordModel(
      {required this.id,
      required this.audio,
      required this.definition,
      required this.acronym,
      required this.partOfSpeech,
      required this.note,
      required this.word});

  static WordModel fromMap(Map<String, dynamic> data) {
    return WordModel(
      id: data["id"] ?? "",
      audio: data["audio"] ?? "",
      definition: data["definition"] ?? "",
      acronym: data["acronym"] ?? "",
      partOfSpeech: data["partofspeech"] ?? "",
      note: data["note"] ?? "",
      word: data["word"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "audio": audio,
      "definition": definition,
      "acronym": acronym,
      "partofspeech": partOfSpeech,
      "note": note,
      "word": word
    };
  }

  WordModel cloneWith({
    id,
    audio,
    definition,
    acronym,
    partOfSpeech,
    note,
    word,
  }) {
    return WordModel(
        id: id ?? this.id,
        audio: audio ?? this.audio,
        definition: definition ?? this.definition,
        acronym: acronym ?? this.acronym,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        note: note ?? this.note,
        word: word ?? this.word);
  }

  @override
  String toString() {
    return "WordModel:{audio:$audio, definition:$definition, acronym:$acronym, partOfSpeech:$partOfSpeech, note:$note, word:$word}";
  }

  @override
  List<Object?> get props => [
        id,
        audio,
        definition,
        acronym,
        partOfSpeech,
        note,
        word,
      ];
}
