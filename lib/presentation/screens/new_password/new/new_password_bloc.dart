import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'new_password_event.dart';
import 'new_password_state.dart';

class NewPasswordBloc extends Bloc<NewPasswordEvent, NewPasswordState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  NewPasswordBloc() : super(NewPasswordState.empty()) {
    on<NewPasswordEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 300));
    });
    on<NewPasswordChanged>((event, emit) async {
      await _mapNewPasswordChangedToState(event, emit);
    });
    on<ConfirmNewPasswordChanged>((event, emit) async {
      await _mapConfirmNewPasswordChangedToState(event, emit);
    });
    on<ResetPassword>((event, emit) async {
      await _mapResetPasswordToState(event, emit);
    });
  }

  EventTransformer<NewPasswordEvent> transformEvents(Duration duration) {
    return (Stream<NewPasswordEvent> events, mapper) {
      var debounceStream = events
          .where((event) =>
              event is NewPasswordChanged || event is ConfirmNewPasswordChanged)
          .debounceTime(const Duration(milliseconds: 300));
      var nonDebounceStream = events.where((event) =>
          event is! NewPasswordChanged || event is! ConfirmNewPasswordChanged);
      return MergeStream([nonDebounceStream, debounceStream]).switchMap(mapper);
    };
  }

  Future<void> _mapResetPasswordToState(
      event, Emitter<NewPasswordState> emit) async {
    String password = event.newPassword;
    try {
      emit(NewPasswordState.loading());
      await _authRepository.resetPassword(password);
      emit(NewPasswordState.success());
    } catch (e) {
      final message = _authRepository.authException;
      emit(NewPasswordState.failure(message));
    }
  }

  Future<void> _mapNewPasswordChangedToState(
      event, Emitter<NewPasswordState> emit) async {
    String newPassword = event.newPassword;
    var isNewPasswordValid = UtilValidators.isValidPassword(newPassword);

    emit(state.update(isNewPasswordValid: isNewPasswordValid));
  }

  Future<void> _mapConfirmNewPasswordChangedToState(
      event, Emitter<NewPasswordState> emit) async {
    String newPassword = event.newPassword;
    String confirm = event.confirmNewPassword;
    var isConfirmNewPasswordValid = UtilValidators.isValidPassword(confirm);
    var isMatched = true;

    if (confirm.isNotEmpty) {
      isMatched = newPassword == confirm;
    }

    emit(state.update(
      isConfirmNewPasswordValid: isConfirmNewPasswordValid && isMatched,
    ));
  }
}
