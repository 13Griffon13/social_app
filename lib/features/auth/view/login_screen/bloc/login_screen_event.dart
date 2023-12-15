import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_screen_event.freezed.dart';

@freezed
class LoginScreenEvent with _$LoginScreenEvent {
  const LoginScreenEvent._();

  const factory LoginScreenEvent.emailChanged(String newValue) = _EmailChanged;

  const factory LoginScreenEvent.passwordChanged(String newValue) = _PasswordChanged;

  const factory LoginScreenEvent.signInAttempt() = _SignInAttempt;

  const factory LoginScreenEvent.showPasswordPressed() =_ShowPasswordPressed;

}