import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'EmailChanged{email: $email}';
  }
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String email;

  const ResetPasswordEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'ResetPassword{email: $email}';
  }
}
