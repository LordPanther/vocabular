import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vocab_app/data/models/daily_word_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/word_repository/word_repo.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/add_word_event.dart';
import 'package:vocab_app/presentation/screens/add_word/bloc/add_word_state.dart';
import 'package:vocab_app/utils/validator.dart';

class AddWordBloc extends Bloc<AddWordEvent, AddWordState> {
  final WordRepository _wordRepository = AppRepository.wordRepository;

  AddWordBloc() : super(AddWordState.empty()) {
    on<AddWordEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 300));
    });
    on<WordChanged>((event, emit) async {
      await _mapWordChangesToState(event, emit);
    });
    on<DefinitionChanged>((event, emit) async {
      await _mapWordChangesToState(event, emit);
    });
    on<AcronymChanged>((event, emit) async {
      await _mapWordChangesToState(event, emit);
    });
    on<NoteChanged>((event, emit) async {
      await _mapWordChangesToState(event, emit);
    });
    on<LoadWord>((event, emit) async {
      await _mapLoadWordToState(event, emit);
    });
  }

  EventTransformer<AddWordEvent> transformEvents(Duration duration) {
    return (Stream<AddWordEvent> events, mapper) {
      final debounceStream = events
          .where((event) => event is WordChanged)
          .debounceTime(const Duration(milliseconds: 100));

      final nonDebounceStream =
          events.where((event) => (event is! WordChanged));

      return MergeStream([
        debounceStream,
        nonDebounceStream,
      ]).switchMap(mapper);
    };
  }

  Future<void> _mapWordChangesToState(event, Emitter<AddWordState> emit) async {
    String word = event.word;
    emit(state.update(
      isWordValid: UtilValidators.isValidWord(word),
    ));
  }

  Future<void> _mapLoadWordToState(event, Emitter<AddWordState> emit) async {
    WordModel word = event.word;

    try {
      emit(AddWordState.loading());
      await _wordRepository.addNewDailyWord(word);

      emit(AddWordState.success());
    } catch (e) {
      final message = _wordRepository.firestoreException;
      emit(AddWordState.failure(message));
    }
  }
}
