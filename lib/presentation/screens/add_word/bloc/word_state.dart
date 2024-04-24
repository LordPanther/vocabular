import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/word_model.dart';

abstract class WordState extends Equatable {
  const WordState();

  @override
  List<Object?> get props => [];
}

class WordAdded extends WordState {
  final WordModel word;

  const WordAdded(this.word);

  @override
  List<Object> get props => [word];

  @override
  String toString() {
    return "{WordAdded: word:${word.toString()}}";
  }
}

class Loaded extends WordState {
  final List<CollectionModel> collections;

  const Loaded(this.collections);

  @override
  List<Object> get props => [collections];

  @override
  String toString() {
    return "{CollectionsRecieved: collections:${collections.toString()}}";
  }
}

class Initial extends WordState {}

class CollectionFailure extends WordState {
  final String error;

  const CollectionFailure(this.error);
}

class WordAddFailure extends WordState {
  final String error;

  const WordAddFailure(this.error);
}
