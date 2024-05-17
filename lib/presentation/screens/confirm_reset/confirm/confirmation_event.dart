import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ConfirmationEvent extends Equatable {
  const ConfirmationEvent();
}

class ConfirmResetCodeEvent extends ConfirmationEvent {
  final String code;
  final String password;
  const ConfirmResetCodeEvent({
    required this.code,
    required this.password,
  });

  @override
  List<Object?> get props => [code, password];

  @override
  String toString() {
    return 'Confirmed{code: $code, password: $password}';
  }
}
