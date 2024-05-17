import 'package:flutter/material.dart';

@immutable
class ConfirmationState {
  final bool isConfirmationCodeValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  const ConfirmationState({
    required this.isConfirmationCodeValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.message,
  });

  factory ConfirmationState.empty() {
    return const ConfirmationState(
      isConfirmationCodeValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory ConfirmationState.confirming() {
    return const ConfirmationState(
        isConfirmationCodeValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: "Confirming ...");
  }

  factory ConfirmationState.failure(String message) {
    return ConfirmationState(
      isConfirmationCodeValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory ConfirmationState.success() {
    return const ConfirmationState(
      isConfirmationCodeValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      message: "Confirmation Sucess",
    );
  }

  ConfirmationState update({bool? isConfirmationCodeValid}) {
    return cloneWith(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  ConfirmationState cloneWith({
    bool? isConfirmationCodeValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return ConfirmationState(
      isConfirmationCodeValid:
          isConfirmationCodeValid ?? this.isConfirmationCodeValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ConfirmationState{isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure, message: $message}';
  }
}
