import 'package:flutter/material.dart';
import 'package:vocab_app/presentation/screens/homep_page/bloc/bloc.dart';

@immutable
class HomePageState {
  final bool isWordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? message;

  bool get isFormValid => isWordValid;

  const HomePageState({
    required this.isWordValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.message,
  });

  factory HomePageState.empty() {
    return const HomePageState(
      isWordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  factory HomePageState.loading() {
    return const HomePageState(
        isWordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        message: "Logging ...");
  }

  factory HomePageState.failure(String message) {
    return HomePageState(
      isWordValid: true,
      isSuccess: false,
      isSubmitting: false,
      isFailure: true,
      message: message,
    );
  }

  factory HomePageState.success() {
    return const HomePageState(
      isWordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      message: "Login Sucess",
    );
  }

  HomePageState update({bool? isWordValid}) {
    return cloneWith(
      isWordValid: isWordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      message: "",
    );
  }

  HomePageState cloneWith({
    bool? isWordValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? message,
  }) {
    return HomePageState(
      isWordValid: isWordValid ?? this.isWordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'HomePageState{isWordValid: $isWordValid}';
  }
}
