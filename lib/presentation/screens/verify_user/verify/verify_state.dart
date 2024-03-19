import 'package:flutter/material.dart';

@immutable
class VerificationState {
  final bool isEmailVerified;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  const VerificationState({
    required this.isEmailVerified,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.message,
  });

  factory VerificationState.empty() {
    return const VerificationState(
      isEmailVerified: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory VerificationState.verifying() {
    return const VerificationState(
        isEmailVerified: false,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: "Verifying ...");
  }

  factory VerificationState.failure(String message) {
    return VerificationState(
      isEmailVerified: false,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory VerificationState.success() {
    return const VerificationState(
      isEmailVerified: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      message: "Verification Sucess",
    );
  }

  VerificationState update({bool? isEmailVerified}) {
    return cloneWith(
      isEmailVerified: isEmailVerified,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  VerificationState cloneWith({
    bool? isEmailVerified,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return VerificationState(
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'VerificationState{isEmailValid: $isEmailVerified, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure, message: $message}';
  }
}
