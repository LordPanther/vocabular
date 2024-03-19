import 'package:equatable/equatable.dart';

abstract class NewPasswordEvent extends Equatable {
  const NewPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPassword extends NewPasswordEvent {
  final String newPassword;

  const ResetPassword({
    required this.newPassword,
  });

  @override
  List<Object> get props => [newPassword];

  @override
  String toString() {
    return 'ResetPassword{newPassword: $newPassword}';
  }
}

class NewPasswordChanged extends NewPasswordEvent {
  final String newPassword;

  const NewPasswordChanged({
    required this.newPassword,
  });

  @override
  String toString() {
    return 'NewPasswordChanged{newPassword: $newPassword}';
  }
}

class ConfirmNewPasswordChanged extends NewPasswordEvent {
  final String newPassword;
  final String confirmNewPassword;

  const ConfirmNewPasswordChanged(
      {required this.newPassword, required this.confirmNewPassword});

  @override
  String toString() {
    return 'ConfirmNewPasswordChanged{newPassword: $newPassword ,confirmNewPassword: $confirmNewPassword}';
  }
}
