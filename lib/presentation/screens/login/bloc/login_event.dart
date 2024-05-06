import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// When user changes email
class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'EmailChanged{email: $email}';
  }
}

/// When user changes password
class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'PasswordChanged{password: $password}';
  }
}

/// When user clicks to login button
class SignInWithCredentials extends LoginEvent {
  final String email;
  final String password;

  const SignInWithCredentials({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// When user clicks to google login button
class SignInWithGoogleSignIn extends LoginEvent {
  const SignInWithGoogleSignIn();

  @override
  List<Object> get props => [];
}

class SignInAsGuest extends LoginEvent {
  const SignInAsGuest();

  @override
  List<Object> get props => [];
}
