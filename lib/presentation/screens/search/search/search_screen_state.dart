import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/word_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class Searching extends SearchState {}

///
class SuggestionLoaded extends SearchState {
  final List<String> recentKeywords;
  final List<String> hotKeywords;

  const SuggestionLoaded(
      {required this.recentKeywords, required this.hotKeywords});

  @override
  List<Object> get props => [recentKeywords, hotKeywords];
}

///
class ResultsLoaded extends SearchState {
  final List<WordModel> wordResults;

  const ResultsLoaded({required this.wordResults});

  @override
  List<Object> get props => [wordResults];
}

///
class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];
}
