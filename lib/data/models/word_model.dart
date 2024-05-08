import 'package:equatable/equatable.dart';

class WordModel extends Equatable {
  final String? id;
  final String? definition;
  final String? word;
  final String? audioUrl;
  final String? timeStamp;
  final bool? isShared;

  const WordModel({
    this.id,
    this.definition,
    this.word,
    this.audioUrl,
    this.timeStamp,
    this.isShared,
  });

  static WordModel fromMap(Map<String, dynamic> data) {
    return WordModel(
      id: data["id"] ?? "",
      definition: data["definition"] ?? "",
      word: data["word"] ?? "",
      audioUrl: data["audioUrl"] ?? "",
      timeStamp: data["timeStamp"] ?? "",
      isShared: data["isShared"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "definition": definition,
      "word": word,
      "audioUrl": audioUrl,
      "timeStamp": timeStamp,
      "isShared": isShared,
    };
  }

  WordModel cloneWith({
    id,
    audioUrl,
    definition,
    word,
    timeStamp,
    isShared,
  }) {
    return WordModel(
      id: id ?? this.id,
      definition: definition ?? this.definition,
      word: word ?? this.word,
      audioUrl: audioUrl ?? this.audioUrl,
      timeStamp: timeStamp ?? this.timeStamp,
      isShared: isShared ?? this.isShared,
    );
  }

  @override
  String toString() {
    return "WordModel:{id:$id, definition:$definition, word:$word, audio:$audioUrl, timeStamp:$timeStamp, isShared: $isShared}";
  }

  @override
  List<Object?> get props => [
        id,
        definition,
        word,
        audioUrl,
        timeStamp,
        isShared,
      ];
}
