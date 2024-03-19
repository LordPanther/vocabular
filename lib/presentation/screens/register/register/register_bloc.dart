import 'package:vocab_app/data/models/user_model.dart';
import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:vocab_app/presentation/screens/register/register/register_event.dart';
import 'package:vocab_app/presentation/screens/register/register/register_state.dart';
import 'package:vocab_app/utils/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  // final UserRepository _userRepository = FirebaseUserRepository();

  RegisterBloc() : super(RegisterState.empty()) {
    on<RegisterEvent>((event, emit) {
      transformEvents(const Duration(milliseconds: 900));
    });
    on<NameChanged>((event, emit) async {
      await _mapNameChangedToState(event, emit);
    });
    on<PhoneChanged>((event, emit) async {
      await _mapPhoneChangedToState(event, emit);
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
    on<Submitted>((event, emit) async {
      await _mapFormSubmittedToState(event, emit);
    });
  }

  EventTransformer<RegisterEvent> transformEvents(Duration duration) {
    return (Stream<RegisterEvent> events, mapper) {
      var debounceStream = events
          .where((event) =>
              event is NameChanged ||
              event is PhoneChanged ||
              event is EmailChanged ||
              event is PasswordChanged ||
              event is ConfirmPasswordChanged)
          .debounceTime(const Duration(milliseconds: 300));
      var nonDebounceStream = events.where((event) =>
          event is! NameChanged &&
          event is! PhoneChanged &&
          event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! ConfirmPasswordChanged);
      return MergeStream([nonDebounceStream, debounceStream]).switchMap(mapper);
    };
  }

  Future<void> _mapNameChangedToState(
      event, Emitter<RegisterState> emit) async {
    String name = event.name;
    emit(state.update(
      isNameValid: UtilValidators.isValidName(name),
    ));
  }

  Future<void> _mapPhoneChangedToState(
      event, Emitter<RegisterState> emit) async {
    String phone = event.phoneNumber;
    emit(state.update(
      isPhoneValid: UtilValidators.isValidPhoneNumber(phone),
    ));
  }

  /// Map from email changed event => states
  Future<void> _mapEmailChangedToState(
      event, Emitter<RegisterState> emit) async {
    String email = event.email;
    emit(state.update(
      isEmailValid: UtilValidators.isValidEmail(email),
    ));
  }

  /// Map from password changed event => states
  Future<void> _mapPasswordChangedToState(
      event, Emitter<RegisterState> emit) async {
    String password = event.password;
    var isPasswordValid = UtilValidators.isValidPassword(password);

    emit(state.update(isPasswordValid: isPasswordValid));
  }

  /// Map from confirmed password changed event => states
  Future<void> _mapConfirmPasswordChangedToState(
      event, Emitter<RegisterState> emit) async {
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
  Future<void> _mapFormSubmittedToState(
      event, Emitter<RegisterState> emit) async {
    UserModel user = event.user;
    String password = event.password;
    try {
      emit(RegisterState.loading());
      await _authRepository.signUp(user, password);

      bool isLoggedIn = _authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(RegisterState.success());
      } else {
        final message = _authRepository.authException;
        // await _authRepository.loggedFirebaseUser.delete();
        // await _userRepository.removeUserData(user);
        emit(RegisterState.failure(message));
      }
    } catch (e) {
      final message = _authRepository.authException;
      emit(RegisterState.failure(message));
    }
  }
}
