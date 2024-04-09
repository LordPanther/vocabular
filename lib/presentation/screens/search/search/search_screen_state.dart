import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/collections_model.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';

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
  final List<WordModel> results;

  const ResultsLoaded(this.results);

  @override
  List<Object> get props => [results];
}

///
class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];
}
