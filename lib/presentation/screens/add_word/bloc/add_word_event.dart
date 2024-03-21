import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

abstract class AddWordEvent extends Equatable {
  const AddWordEvent();

  @override
  List<Object> get props => [];
}

class WordChanged extends AddWordEvent {
  final String word;

  const WordChanged({required this.word});

  @override
  List<Object> get props => [word];

  @override
  String toString() {
    return 'WordChange{name: $word}';
  }
}

class DefinitionChanged extends AddWordEvent {
  final String definition;

  const DefinitionChanged({required this.definition});

  @override
  List<Object> get props => [definition];

  @override
  String toString() {
    return 'DefinitionChanged{name: $definition}';
  }
}

class AcronymChanged extends AddWordEvent {
  final String acronym;

  const AcronymChanged({required this.acronym});

  @override
  List<Object> get props => [acronym];

  @override
  String toString() {
    return 'AcronymChanged{name: $acronym}';
  }
}

class NoteChanged extends AddWordEvent {
  final String note;

  const NoteChanged({required this.note});

  @override
  List<Object> get props => [note];

  @override
  String toString() {
    return 'NoteChanged{name: $note}';
  }
}

class LoadWord extends AddWordEvent {
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
