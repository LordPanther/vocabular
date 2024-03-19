import 'package:vocab_app/configs/language.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(InitialLanguageState()) {
    on<LanguageChanged>((event, emit) async {
      await _mapEventToState(event, emit);
    });
  }

  Future<void> _mapEventToState(event, Emitter<LanguageState> emit) async {
    if (event.locale == AppLanguage.defaultLanguage) {
      emit(LanguageUpdated());
    } else {
      emit(LanguageUpdating());
      AppLanguage.defaultLanguage = event.locale;
      await LocalPref.setString("language", event.locale.languageCode);
      emit(LanguageUpdated());
    }
  }
}
