import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String id;
  final String definition;
  final String word;

  const WordModel(
      {required this.id,
      required this.definition,
      required this.word});

  static WordModel fromMap(Map<String, dynamic> data) {
    return WordModel(
      id: data["id"] ?? "",
      definition: data["definition"] ?? "",
      word: data["word"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "definition": definition,
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
        definition: definition ?? this.definition,
        word: word ?? this.word);
  }

  @override
  String toString() {
    return "WordModel:{id:$id, definition:$definition, word:$word}";
  }

  @override
  List<Object?> get props => [
        id,
        definition,
        word,
      ];
}
