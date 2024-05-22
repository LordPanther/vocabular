// ignore_for_file: depend_on_referenced_packages

import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isNameValid;
  final bool isPhoneValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  bool get isFormValid =>
      isEmailValid && isPasswordValid && isConfirmPasswordValid;

  const RegisterState(
      {required this.isNameValid,
      required this.isPhoneValid,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isConfirmPasswordValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure,
      this.message});

  factory RegisterState.empty() {
    return const RegisterState(
      isNameValid: true,
      isPhoneValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory RegisterState.loading() {
    return const RegisterState(
      isNameValid: true,
      isPhoneValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      message: "Registering ...",
    );
  }

  factory RegisterState.failure(String message) {
    return RegisterState(
      isNameValid: true,
      isPhoneValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory RegisterState.success() {
    return const RegisterState(
        isNameValid: true,
        isPhoneValid: true,
        isEmailValid: true,
        isPasswordValid: true,
        isConfirmPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: "Register success");
  }

  RegisterState update(
      {bool? isNameValid,
      bool? isPhoneValid,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isConfirmPasswordValid}) {
    return cloneWith(
      isNameValid: isNameValid,
      isPhoneValid: isPhoneValid,
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  RegisterState cloneWith({
    bool? isPhoneValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isNameValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return RegisterState(
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
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
    return 'RegisterState{isNameValid: $isNameValid, isPhoneValid: $isPhoneValid, isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid, isConfirmPasswordValid: $isConfirmPasswordValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
