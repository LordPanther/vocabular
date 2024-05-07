import 'dart:async';
import 'package:vocab_app/configs/application.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/auth_event.dart';
import '../common_bloc.dart';
import '../language/language_event.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final Application application = Application();

  ApplicationBloc() : super(ApplicationInitial()) {
    on<SetupApplicationEvent>((event, emit) async {
      await mapEventToState(emit);
    });
  }

  Future<void> mapEventToState(Emitter<ApplicationState> emit) async {
    /// Setup SharedPreferences
    await application.setPreferences();

    /// Get old settings
    final oldLanguage = LocalPref.getString("language");

    if (oldLanguage != null) {
      CommonBloc.languageBloc.add(LanguageChanged(Locale(oldLanguage)));
    }

    /// Authentication begin check
    CommonBloc.authencationBloc.add(AuthenticationStarted());

    emit(ApplicationCompleted());
  }
}
