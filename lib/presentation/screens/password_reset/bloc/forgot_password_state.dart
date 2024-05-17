import 'package:meta/meta.dart';

@immutable
class ForgotPasswordState {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  bool get isFormValid => isEmailValid;

  const ForgotPasswordState(
      {required this.isEmailValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure,
      this.message});

  factory ForgotPasswordState.empty() {
    return const ForgotPasswordState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory ForgotPasswordState.loading() {
    return const ForgotPasswordState(
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      message: "Resetting ...",
    );
  }

  factory ForgotPasswordState.failure(String message) {
    return ForgotPasswordState(
      isEmailValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory ForgotPasswordState.success() {
    return const ForgotPasswordState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        message: "Reset success");
  }

  ForgotPasswordState update({
    bool? isEmailValid,
  }) {
    return cloneWith(
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  ForgotPasswordState cloneWith({
    bool? isNewPasswordValid,
    bool? isConfirmNewPasswordValid,
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return ForgotPasswordState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ForgotPasswordState{isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
