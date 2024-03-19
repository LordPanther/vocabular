import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository = AppRepository.authRepository;

  ForgotPasswordBloc() : super(ForgotPasswordState.empty()) {
    on<ForgotPasswordEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 300));
    });
    on<EmailChanged>((event, emit) async {
      await _mapEmailChangedToState(event, emit);
    });
    on<ResetPasswordEvent>((event, emit) async {
      await _mapSendResetEmailToState(event, emit);
    });
  }

  EventTransformer<ForgotPasswordEvent> transformEvents(Duration duration) {
    return (Stream<ForgotPasswordEvent> events, mapper) {
      var debounceStream = events
          .where((event) => event is EmailChanged)
          .debounceTime(const Duration(milliseconds: 300));
      var nonDebounceStream = events.where((event) => event is! EmailChanged);
      return MergeStream([nonDebounceStream, debounceStream]).switchMap(mapper);
    };
  }

  Future<void> _mapEmailChangedToState(
      event, Emitter<ForgotPasswordState> emit) async {
    String email = event.email;
    emit(state.update(isEmailValid: UtilValidators.isValidEmail(email)));
  }

  Future<void> _mapSendResetEmailToState(
      event, Emitter<ForgotPasswordState> emit) async {
    String email = event.email;
    try {
      emit(ForgotPasswordState.loading());
      await _authRepository.resetPassword(email);

      emit(ForgotPasswordState.success());
    } catch (e) {
      emit(ForgotPasswordState.failure("Password Reset Failure"));
    }
  }
}
