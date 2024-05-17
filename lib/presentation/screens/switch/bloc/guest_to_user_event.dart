import 'package:equatable/equatable.dart';
import 'package:vocab_app/data/models/user_model.dart';

abstract class GuestToUserEvent extends Equatable {
  const GuestToUserEvent();

  @override
  List<Object> get props => [];
}

/// When user changes email
class EmailChanged extends GuestToUserEvent {
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
class PasswordChanged extends GuestToUserEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'PasswordChanged{password: $password}';
  }
}

/// When user changes confirmed password
class ConfirmPasswordChanged extends GuestToUserEvent {
  final String password;
  final String confirmPassword;

  const ConfirmPasswordChanged(
      {required this.password, required this.confirmPassword});

  @override
  String toString() {
    return 'ConfirmPasswordChanged{password: $password ,confirmPassword: $confirmPassword}';
  }
}

/// When user clicks to login button
class SwitchUser extends GuestToUserEvent {
  final UserModel user;
  final String password;
  final String confirmPassword;

  const SwitchUser({required this.user, required this.password, required this.confirmPassword});

  @override
  List<Object> get props => [user.email!];
}
