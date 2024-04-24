import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:vocab_app/data/models/word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/home_repository/home_repo.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_event.dart';
import 'package:vocab_app/presentation/screens/search/search/search_screen_state.dart';
import 'package:vocab_app/utils/collection_data.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepository _homeRepository = AppRepository.collectionsRepository;

  SearchBloc() : super(Searching()) {
    on<SearchEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 1500));
    });
    on<OpenScreen>((event, emit) async {
      await _mapOpenScreenToState(event, emit);
    });
    on<KeywordChanged>((event, emit) async {
      await _mapKeywordChangedToState(event, emit);
    });
  }

  /// Debounce search query changed event
  EventTransformer<SearchEvent> transformEvents(Duration duration) {
    return (Stream<SearchEvent> events, mapper) {
      var debounceStream = events
          .where((event) => event is KeywordChanged)
          .debounceTime(const Duration(milliseconds: 500));
      var nonDebounceStream = events.where((event) => event is! KeywordChanged);
      return MergeStream([nonDebounceStream, debounceStream]).switchMap(mapper);
    };
  }

  Future<void> _mapOpenScreenToState(event, Emitter<SearchState> emit) async {
    try {
      List<String> recentKeywords = await _getRecentKeywords();
      emit(SuggestionLoaded(
        recentKeywords: recentKeywords,
        hotKeywords: hotKeywords,
      ));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  Future<void> _mapKeywordChangedToState(
      event, Emitter<SearchState> emit) async {
    String keyword = event.keyword;

    emit(Searching());
    try {
      List<String> recentKeywords = await _getRecentKeywords();
      if (keyword.isEmpty) {
        emit(SuggestionLoaded(
          recentKeywords: recentKeywords,
          hotKeywords: hotKeywords,
        ));
      } else {
        // Get collections and words
        CollectionData data = await _homeRepository.fetchCollections();

        // Search for words within collections
        List<WordModel> results = [];
        for (var collection in data.collections) {
          for (var words in data.words) {
            results.addAll(words.where((word) =>
                word.word.toLowerCase().contains(keyword.toLowerCase())));
          }
        }

        emit(ResultsLoaded(wordResults: results));

        // Store keyword locally
        if (!recentKeywords.contains(keyword.toLowerCase())) {
          if (recentKeywords.length > 9) {
            recentKeywords.removeAt(0);
          }
          recentKeywords.add(keyword.toLowerCase());
          await LocalPref.setStringList("recentKeywords", recentKeywords);
        }
      }
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  Future<List<String>> _getRecentKeywords() async {
    return LocalPref.getStringList("recentKeywords") ?? [];
  }
}

const List<String> hotKeywords = [
  "vocabular",
];
