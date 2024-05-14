import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppSettingsEvent extends Equatable {}

class ChangeLanguage extends AppSettingsEvent {
  final Locale locale;

  ChangeLanguage(this.locale);

  @override
  List<Object> get props => [locale];
}

class ChangeWordOption extends AppSettingsEvent {
  final bool showRecentWord;

  ChangeWordOption(this.showRecentWord);

  @override
  List<Object> get props => [showRecentWord];
}

class ChangeTheme extends AppSettingsEvent {
  final ThemeData mode;

  ChangeTheme(this.mode);

  @override
  List<Object> get props => [mode];
}
