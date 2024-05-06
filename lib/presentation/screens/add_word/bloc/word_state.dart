import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/add_word_model.dart';
import 'package:vocab_app/data/models/collections_model.dart';

abstract class WordState extends Equatable {
  const WordState();

  @override
  List<Object?> get props => [];
}

class WordAdded extends WordState {
  final AddWordModel word;

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
  final User user; 

  const Loaded(this.collections, this.user);

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
