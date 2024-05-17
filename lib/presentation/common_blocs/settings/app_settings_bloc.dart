import 'dart:async';

import 'package:vocab_app/configs/language.dart';
import 'package:vocab_app/configs/settings.dart';
import 'package:vocab_app/data/local/pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(InitialSetupState()) {
    on<ChangeLanguage>((event, emit) async {
      await _mapLanguageChangedState(event, emit);
    });
    on<ChangeTheme>((event, emit) async {
      await _mapThemeChangedState(event, emit);
    });
    on<ChangeRecentWordSetting>((event, emit) async {
      await _mapShowHideToState(event, emit);
    });
  }

  /// Word

  Future<void> _mapShowHideToState(
      event, Emitter<AppSettingsState> emit) async {
    if (event.setting == RecentWordSetting.defaultWordSetting) {
      emit(WordSettingUpdated());
    } else {
      emit(WordSettingUpdating());
      RecentWordSetting.defaultWordSetting = event.setting;
      await LocalPref.setBool("showRecentWord", event.setting);
      emit(WordSettingUpdated());
    }
  }

  /// Language

  Future<void> _mapLanguageChangedState(
      event, Emitter<AppSettingsState> emit) async {
    if (event.locale == AppLanguage.defaultLanguage) {
      emit(LanguageUpdated());
    } else {
      emit(LanguageUpdating());
      AppLanguage.defaultLanguage = event.locale;
      await LocalPref.setString("language", event.locale.languageCode);
      emit(LanguageUpdated());
    }
  }

  Future<void> _mapThemeChangedState(
      event, Emitter<AppSettingsState> emit) async {
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
