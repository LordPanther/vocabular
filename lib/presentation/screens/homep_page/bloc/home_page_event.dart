import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class WordChanges extends HomePageEvent {
  final String word;

  const WordChanges({required this.word});

  @override
  List<Object> get props => [word];

  @override
  String toString() {
    return 'WordChange{name: $word}';
  }
}

class LoadWord extends HomePageEvent {
  final WordModel word;

  const LoadWord({
    required this.word,
  });

  @override
  List<Object> get props => [word.word];

  @override
  String toString() {
    return 'Loaded{name: ${word.word}';
  }
}
