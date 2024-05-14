import 'package:vocab_app/data/repository/app_repository.dart';
import 'package:vocab_app/data/repository/auth_repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository = AppRepository.authRepository;
  // final UserRepository _userRepository = AppRepository.userRepository;

  AuthenticationBloc() : super(Uninitialized()) {
    on<AuthenticationStarted>((event, emit) async {
      await _mapAppStartedToState(emit);
    });
    on<LogIn>((event, emit) async {
      await _mapLoggedInToState(emit);
    });
    on<LogOut>((event, emit) async {
      await _mapLoggedOutToState(emit);
    });
  }

  Future<void> _mapAppStartedToState(Emitter<AuthenticationState> emit) async {
    try {
      bool isLoggedIn = _authRepository.isLoggedIn();

      await Future.delayed(const Duration(seconds: 5));

      if (isLoggedIn) {
        final loggedFirebaseUser = _authRepository.currentUser;
        emit(Authenticated(loggedFirebaseUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _mapLoggedInToState(Emitter<AuthenticationState> emit) async {
    emit(Authenticated(_authRepository.currentUser));
  }

  Future<void> _mapLoggedOutToState(Emitter<AuthenticationState> emit) async {
    emit(Unauthenticated());
    _authRepository.logOut();
  }
}
