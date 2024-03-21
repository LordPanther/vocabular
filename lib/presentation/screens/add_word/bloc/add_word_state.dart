import 'package:flutter/material.dart';

@immutable
class AddWordState {
  final bool isWordValid;
  final bool isDefinitionValid;
  final bool isAcronymValid;
  final bool isNoteValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  bool get isFormValid =>
      isWordValid && isDefinitionValid && isAcronymValid && isNoteValid;

  const AddWordState({
    required this.isWordValid,
    required this.isDefinitionValid,
    required this.isAcronymValid,
    required this.isNoteValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.message,
  });

  factory AddWordState.empty() {
    return const AddWordState(
      isWordValid: true,
      isAcronymValid: true,
      isDefinitionValid: true,
      isNoteValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory AddWordState.loading() {
    return const AddWordState(
        isWordValid: true,
        isAcronymValid: true,
        isDefinitionValid: true,
        isNoteValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: "Logging ...");
  }

  factory AddWordState.failure(String message) {
    return AddWordState(
      isWordValid: true,
      isAcronymValid: true,
      isDefinitionValid: true,
      isNoteValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory AddWordState.success() {
    return const AddWordState(
      isWordValid: true,
      isAcronymValid: true,
      isDefinitionValid: true,
      isNoteValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      message: "Login Sucess",
    );
  }

  AddWordState update({
    bool? isWordValid,
    bool? isDefinitionValid,
    bool? isAcronymValid,
    bool? isNoteValid,
  }) {
    return cloneWith(
      isWordValid: isWordValid,
      isDefinitionValid: isDefinitionValid,
      isAcronymValid: isAcronymValid,
      isNoteValid: isNoteValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  AddWordState cloneWith({
    bool? isWordValid,
    bool? isDefinitionValid,
    bool? isAcronymValid,
    bool? isNoteValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return AddWordState(
      isWordValid: isWordValid ?? this.isWordValid,
      isDefinitionValid: isDefinitionValid ?? this.isDefinitionValid,
      isAcronymValid: isAcronymValid ?? this.isAcronymValid,
      isNoteValid: isNoteValid ?? this.isNoteValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'AddWordState{isWordValid: $isWordValid, isDefinitionValid: $isDefinitionValid, isAcronymValid: $isAcronymValid, isNoteValid: $isNoteValid}';
  }
}
