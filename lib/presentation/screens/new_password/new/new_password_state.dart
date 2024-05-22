// ignore_for_file: depend_on_referenced_packages

import 'package:meta/meta.dart';

@immutable
class NewPasswordState {
  final bool isNewPasswordValid;
  final bool isConfirmNewPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  bool get isPasswordFormValid =>
      isNewPasswordValid && isConfirmNewPasswordValid;

  const NewPasswordState(
      {required this.isNewPasswordValid,
      required this.isConfirmNewPasswordValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure,
      this.message});

  factory NewPasswordState.empty() {
    return const NewPasswordState(
      isNewPasswordValid: true,
      isConfirmNewPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory NewPasswordState.loading() {
    return const NewPasswordState(
      isNewPasswordValid: true,
      isConfirmNewPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      message: "Resetting ...",
    );
  }

  factory NewPasswordState.failure(String message) {
    return NewPasswordState(
      isNewPasswordValid: true,
      isConfirmNewPasswordValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory NewPasswordState.success() {
    return const NewPasswordState(
        isNewPasswordValid: true,
        isConfirmNewPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: "Resetting success");
  }

  NewPasswordState update({
    bool? isNewPasswordValid,
    bool? isConfirmNewPasswordValid,
  }) {
    return cloneWith(
      isNewPasswordValid: isNewPasswordValid,
      isConfirmNewPasswordValid: isConfirmNewPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  NewPasswordState cloneWith({
    bool? isNewPasswordValid,
    bool? isConfirmNewPasswordValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return NewPasswordState(
      isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
      isConfirmNewPasswordValid:
          isConfirmNewPasswordValid ?? this.isConfirmNewPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ResetPasswordState{newEmail: $isNewPasswordValid, confirmNewEmail: $isConfirmNewPasswordValid}';
  }
}
