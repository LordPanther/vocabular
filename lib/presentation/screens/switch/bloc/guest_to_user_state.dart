// ignore_for_file: depend_on_referenced_packages

import 'package:meta/meta.dart';

@immutable
class GuestToUserState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  bool get isFormValid =>
      isEmailValid && isPasswordValid && isConfirmPasswordValid;

  const GuestToUserState(
      {
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isConfirmPasswordValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure,
      this.message});

  factory GuestToUserState.empty() {
    return const GuestToUserState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory GuestToUserState.loading() {
    return const GuestToUserState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      message: "Registering ...",
    );
  }

  factory GuestToUserState.failure(String message) {
    return GuestToUserState(
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory GuestToUserState.success() {
    return const GuestToUserState(
        isEmailValid: true,
        isPasswordValid: true,
        isConfirmPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: "Register success");
  }

  GuestToUserState update(
      {
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isConfirmPasswordValid}) {
    return cloneWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  GuestToUserState cloneWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return GuestToUserState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'GuestToUserState{isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid, isConfirmPasswordValid: $isConfirmPasswordValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
