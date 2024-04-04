import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class CreateWord extends HomeEvent {
  final CollectionModel collection;
  final WordModel word;
  final bool shareWord;
  const CreateWord(
      {required this.collection, required this.word, required this.shareWord});

  @override
  List<Object> get props => [collection, word, shareWord];
}

class RemoveWord extends HomeEvent {
  final CollectionModel collection;
  final WordModel word;
  const RemoveWord({required this.collection, required this.word});

  @override
  List<Object> get props => [collection, word];
}

class LoadHome extends HomeEvent {}

class RefreshHome extends HomeEvent {}
