import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/presentation/screens/guest_to_user_screen/bloc/guest_to_user_event.dart';
import 'package:vocab_app/presentation/screens/guest_to_user_screen/bloc/guest_to_user_state.dart';
import 'package:vocab_app/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class GuestToUserBloc extends Bloc<GuestToUserEvent, GuestToUserState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  GuestToUserBloc() : super(GuestToUserState.empty()) {
    on<GuestToUserEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 900));
    });
    on<EmailChanged>((event, emit) async {
      await _mapEmailChangedToState(event, emit);
    });
    on<PasswordChanged>((event, emit) async {
      await _mapPasswordChangedToState(event, emit);
    });
    on<ConfirmPasswordChanged>((event, emit) async {
      await _mapConfirmPasswordChangedToState(event, emit);
    });
    on<SwitchUser>((event, emit) async {
      await _mapFormSwitchUserToState(event, emit);
    });
  }

  EventTransformer<GuestToUserEvent> transformEvents(Duration duration) {
    return (Stream<GuestToUserEvent> events, mapper) {
      var debounceStream = events
          .where((event) =>
              event is EmailChanged ||
              event is PasswordChanged ||
              event is ConfirmPasswordChanged)
          .debounceTime(const Duration(milliseconds: 300));
      var nonDebounceStream = events.where((event) =>
          event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! ConfirmPasswordChanged);
      return MergeStream([nonDebounceStream, debounceStream]).switchMap(mapper);
    };
  }

  /// Map from email changed event => states
  Future<void> _mapEmailChangedToState(
      event, Emitter<GuestToUserState> emit) async {
    String email = event.email;
    emit(state.update(
      isEmailValid: UtilValidators.isValidEmail(email),
    ));
  }

  /// Map from password changed event => states
  Future<void> _mapPasswordChangedToState(
      event, Emitter<GuestToUserState> emit) async {
    String password = event.password;
    var isPasswordValid = UtilValidators.isValidPassword(password);

    emit(state.update(isPasswordValid: isPasswordValid));
  }

  /// Map from confirmed password changed event => states
  Future<void> _mapConfirmPasswordChangedToState(
      event, Emitter<GuestToUserState> emit) async {
    String password = event.password;
    String confirm = event.confirmPassword;
    var isConfirmPasswordValid = UtilValidators.isValidPassword(confirm);
    var isMatched = true;

    if (confirm.isNotEmpty) {
      isMatched = password == confirm;
    }

    emit(state.update(
      isConfirmPasswordValid: isConfirmPasswordValid && isMatched,
    ));
  }

  /// Map from submit event => states
  Future<void> _mapFormSwitchUserToState(
      event, Emitter<GuestToUserState> emit) async {
    UserModel user = event.user;
    String password = event.password;
    try {
      emit(GuestToUserState.loading());
      await _authRepository.switchUser(user, password);

      bool isLoggedIn = _authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(GuestToUserState.success());
      } else {
        final message = _authRepository.authException;
        emit(GuestToUserState.failure(message));
      }
    } catch (e) {
      final message = _authRepository.authException;
      emit(GuestToUserState.failure(message));
    }
  }
}
