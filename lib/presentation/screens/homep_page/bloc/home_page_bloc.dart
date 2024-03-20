import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/word_repository/word_repo.dart';
import 'package:vocab_app/presentation/screens/homep_page/bloc/home_page_event.dart';
import 'package:vocab_app/utils/validator.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final WordRepository _wordRepository = AppRepository.wordRepository;

  HomePageBloc() : super(HomePageState.empty()) {
    on<HomePageEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 300));
    });
    on<WordChanges>((event, emit) async {
      await _mapWordChangesToState(event, emit);
    });
    on<LoadWord>((event, emit) async {
      await _mapLoadWordToState(event, emit);
    });
  }

  EventTransformer<HomePageEvent> transformEvents(Duration duration) {
    return (Stream<HomePageEvent> events, mapper) {
      final debounceStream = events
          .where((event) => event is WordChanges)
          .debounceTime(const Duration(milliseconds: 100));

      final nonDebounceStream = events.where(
          (event) => (event is! WordChanges));

      return MergeStream([
        debounceStream,
        nonDebounceStream,
      ]).switchMap(mapper);
    };
  }

  Future<void> _mapWordChangesToState(
      event, Emitter<HomePageState> emit) async {
    String word = event.word;
    emit(state.update(
      isWordValid: UtilValidators.isValidWord(word),
    ));
  }

  Future<void> _mapLoadWordToState(
      event, Emitter<HomePageState> emit) async {
    WordModel word = event.word;
    
    try {
      emit(HomePageState.loading());
      await _wordRepository.addNewDailyWord(word);

      emit(HomePageState.success());
    } else {
      final message = _wordRepository.
    }
  }







  


}