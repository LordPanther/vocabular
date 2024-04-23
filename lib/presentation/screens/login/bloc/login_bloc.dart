import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/presentation/screens/login/bloc/login_event.dart';
import 'package:vocab_app/presentation/screens/login/bloc/login_state.dart';
import 'package:vocab_app/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  // CameraPosition? position;

  LoginBloc() : super(LoginState.empty()) {
    on<LoginEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 300));
    });
    on<LoginWithCredential>((event, emit) async {
      await _mapLoginWithCredentialToState(event, emit);
    });
    on<LoginWithGoogleSignIn>((event, emit) async {
      await _mapLoginWithGoogleSignInToState(event, emit);
    });
    on<EmailChanged>((event, emit) async {
      await _mapEmailChangedToState(event, emit);
    });
    on<PasswordChanged>((event, emit) async {
      await _mapPasswordChangedToState(event, emit);
    });
  }

  EventTransformer<LoginEvent> transformEvents(Duration duration) {
    return (Stream<LoginEvent> events, mapper) {
      final debounceStream = events
          .where((event) => event is EmailChanged || event is PasswordChanged)
          .debounceTime(const Duration(milliseconds: 100));

      final nonDebounceStream = events.where(
          (event) => (event is! EmailChanged || event is! PasswordChanged));

      return MergeStream([
        debounceStream,
        nonDebounceStream,
      ]).switchMap(mapper);
    };
  }

  /// Map from email changed event => states
  Future<void> _mapEmailChangedToState(event, Emitter<LoginState> emit) async {
    emit(state.update(isEmailValid: UtilValidators.isValidEmail(event.email)));
  }

  /// Map from  password changed event => states
  Future<void> _mapPasswordChangedToState(
      event, Emitter<LoginState> emit) async {
    String password = event.password;
    emit(state.update(
        isPasswordValid: UtilValidators.isValidPassword(password)));
  }

  Future<void> _mapLoginWithGoogleSignInToState(
      event, Emitter<LoginState> emit) async {
    try {
      emit(LoginState.logging());

      await _authRepository.logInWithGoogle();
      bool isLoggedIn = _authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(LoginState.success());
      } else {
        final message = _authRepository.authException;
        emit(LoginState.failure(
          "$message google",
        ));
      }
    } catch (e) {
      final message = _authRepository.authException;
      emit(LoginState.failure(message));
    }
  }

  /// Map from login event => states
  Future<void> _mapLoginWithCredentialToState(
      event, Emitter<LoginState> emit) async {
    String email = event.email;
    String password = event.password;
    try {
      emit(LoginState.logging());

      await _authRepository.logInWithEmailAndPassword(email, password);
      bool isLoggedIn = _authRepository.isLoggedIn();

      if (isLoggedIn) {
        emit(LoginState.success());
      } else {
        final message = _authRepository.authException;
        emit(LoginState.failure(message));
      }
    } catch (e) {
      final message = _authRepository.authException;
      emit(LoginState.failure(message));
    }
  }
}
