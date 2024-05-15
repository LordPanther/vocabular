import 'dart:async';
import 'package:vocab_app/configs/application.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app/presentation/common_blocs/app_settings/bloc.dart';
import '../auth/auth_event.dart';
import '../common_bloc.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final Application application = Application();

  ApplicationBloc() : super(ApplicationInitial()) {
    on<SetupApplicationEvent>((event, emit) async {
      await _mapEventToState(emit);
    });
  }

  Future<void> _mapEventToState(Emitter<ApplicationState> emit) async {
    /// Setup SharedPreferences
    await application.setPreferences();

    /// Get old settings
    final oldLanguage = LocalPref.getString("language");

    final recentWordSetting = LocalPref.getBool("showRecentWord");

    if (oldLanguage != null) {
      CommonBloc.appSettingsBloc.add(ChangeLanguage(Locale(oldLanguage)));
    }

    if (recentWordSetting != null) {
      CommonBloc.appSettingsBloc.add(ShowHideRecentWord(recentWordSetting));
    }

    /// Authentication begin check
    CommonBloc.authencationBloc.add(AuthenticationStarted());

    emit(ApplicationCompleted());
  }
}
