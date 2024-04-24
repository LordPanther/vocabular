import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String id;
  final String definition;
  final String word;
  final String? audioUrl;

  const WordModel(
      {required this.id,
      required this.definition,
      required this.word,
      this.audioUrl});

  static WordModel fromMap(Map<String, dynamic> data) {
    return WordModel(
      id: data["id"] ?? "",
      definition: data["definition"] ?? "",
      word: data["word"] ?? "",
      audioUrl: data["audiourl"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "definition": definition,
      "word": word,
      "audioUrl": audioUrl
    };
  }

  WordModel cloneWith({
    id,
    audioUrl,
    definition,
    word,
  }) {
    return WordModel(
      id: id ?? this.id,
      definition: definition ?? this.definition,
      word: word ?? this.word,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }

  @override
  String toString() {
    return "WordModel:{id:$id, definition:$definition, word:$word, audio:$audioUrl}";
  }

  @override
  List<Object?> get props => [
        id,
        definition,
        word,
        audioUrl,
      ];
}
