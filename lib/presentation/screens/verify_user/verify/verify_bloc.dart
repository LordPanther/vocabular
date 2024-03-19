import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'verify_event.dart';
import 'verify_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  VerificationBloc() : super(VerificationState.empty()) {
    on<SendVerificationEmailEvent>((event, emit) async {
      await _mapVerifyEmailToState(event, emit);
    });
    on<ReloadUserEvent>((event, emit) async {
      await _mapCheckVerificationToState(event, emit);
    });
  }

  Future<void> _mapVerifyEmailToState(
      event, Emitter<VerificationState> emit) async {
    try {
      emit(VerificationState.verifying());

      // Get current user and verification status
      User? user = _firebaseAuth.currentUser;
      bool isVerified = _authRepository.isVerified();

      // Verify email if user is not null and not already verified
      if (user != null && !isVerified) {
        await _authRepository.verify();
      }

      // Reload user data
      await _authRepository.reloadUsers();

      // Check verification status every 5 seconds
      await _checkVerificationStatusWithDelay(emit);
    } catch (error) {
      if (error is FirebaseAuthException) {
        final message = _authRepository.authException;
        emit(VerificationState.failure(message));
      } else {
        emit(VerificationState.failure("Unexpected error occured"));
      }
    }
  }

  Future<void> _mapCheckVerificationToState(
      evnt, Emitter<VerificationState> emit) async {
    await _authRepository.reloadUsers();
  }

  Future<void> _checkVerificationStatusWithDelay(
      Emitter<VerificationState> emit) async {
    await Future.delayed(const Duration(seconds: 5));

    // Reload user data
    await _firebaseAuth.currentUser?.reload();

    if (_authRepository.isVerified()) {
      emit(VerificationState.success());
    } else {
      // Continue checking verification status recursively
      await _checkVerificationStatusWithDelay(emit);
    }
  }
}
