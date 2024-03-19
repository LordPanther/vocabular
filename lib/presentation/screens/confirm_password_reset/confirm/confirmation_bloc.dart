import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository _authRepository = AppRepository.authRepository;

  ConfirmationBloc() : super(ConfirmationState.empty()) {
    on<ConfirmResetCodeEvent>((event, emit) async {
      await _mapConfirmPasswordReset(event, emit);
    });
  }

  Future<void> _mapConfirmPasswordReset(
      event, Emitter<ConfirmationState> emit) async {
    // String code = event.code;
    // String password = event.password;
    try {
      emit(ConfirmationState.confirming());
      // await _authRepository.confirmPasswordReset(code, password);

      emit(ConfirmationState.success());
    } catch (e) {
      final message = _authRepository.authException;
      emit(ConfirmationState.failure(message));
    }
  }
}
