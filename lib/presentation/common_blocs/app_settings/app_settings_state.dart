import 'package:equatable/equatable.dart';

abstract class AppSettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialSetupState extends AppSettingsState {}

class LanguageUpdating extends AppSettingsState {}

class LanguageUpdated extends AppSettingsState {}

class ShowRecentWordUpdating extends AppSettingsState {}

class ShowRecentWordUpdated extends AppSettingsState {}

class ThemeUpdating extends AppSettingsState {}

class ThemeUpdated extends AppSettingsState {}
