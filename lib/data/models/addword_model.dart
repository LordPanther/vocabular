import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';

class AddWordModel extends Equatable {
  final WordModel word;
  final CollectionModel collection;

  const AddWordModel({
    required this.word,
    required this.collection
  });

  static AddWordModel fromMap(Map<String, dynamic> data) {
    return AddWordModel(
      word: data["word"] ?? "",
      collection: data["collection"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "word": word,
      "collection": collection
    };
  }

  AddWordModel cloneWith({
    word,
    collection,
  }) {
    return AddWordModel(
      word: word ?? this.word,
      collection: collection ?? this.collection,
    );
  }

  @override
  String toString() {
    return "AddWordModel:{id:$word, definition:$collection}";
  }

  @override
  List<Object?> get props => [
        word,
        collection,
      ];
}
