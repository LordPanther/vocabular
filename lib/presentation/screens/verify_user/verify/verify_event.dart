import 'package:flutter/material.dart';

@immutable
abstract class VerificationEvent {
  const VerificationEvent();
}

class SendVerificationEmailEvent extends VerificationEvent {
  const SendVerificationEmailEvent();
}

class ReloadUserEvent extends VerificationEvent {
  const ReloadUserEvent();
}
