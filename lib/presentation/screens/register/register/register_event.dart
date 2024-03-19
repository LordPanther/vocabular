import 'package:vocab_app/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class PhoneChanged extends RegisterEvent {
  final String phoneNumber;

  const PhoneChanged({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() {
    return 'PhoneChange{phoneNumber: $phoneNumber}';
  }
}

class NameChanged extends RegisterEvent {
  final String name;

  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'NameChange{name: $name}';
  }
}

/// When user changes email
class EmailChanged extends RegisterEvent {
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
class PasswordChanged extends RegisterEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  String toString() {
    return 'PasswordChanged{password: $password}';
  }
}

/// When user changes confirmed password
class ConfirmPasswordChanged extends RegisterEvent {
  final String password;
  final String confirmPassword;

  const ConfirmPasswordChanged(
      {required this.password, required this.confirmPassword});

  @override
  String toString() {
    return 'ConfirmPasswordChanged{password: $password ,confirmPassword: $confirmPassword}';
  }
}

/// When clicks to register button
class Submitted extends RegisterEvent {
  final UserModel user; // contains new user's information
  final String password;
  final String confirmPassword;

  const Submitted({
    required this.user,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [user.email];

  @override
  String toString() {
    return 'Submitted{name: ${user.firstName}, phoneNumber: ${user.phoneNumber}, email: ${user.email}, password: $password, confirmPassword: $confirmPassword}';
  }
}
