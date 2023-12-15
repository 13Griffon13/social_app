import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_screen_event.freezed.dart';

@freezed
class SignUpScreenEvent with _$SignUpScreenEvent {
  const SignUpScreenEvent._();


  const factory SignUpScreenEvent.resetState() = _ResetState;

  const factory SignUpScreenEvent.emailFieldChanged(
      {required String newValue}) = _EmailFieldChanged;

  const factory SignUpScreenEvent.passwordFieldChanged(
      {required String newValue}) = _PasswordFieldChanged;

  const factory SignUpScreenEvent.repeatPasswordFieldChanged(
      {required String newValue}) = _RepeatPasswordFieldChanged;

  const factory SignUpScreenEvent.showPasswordPressed() = _ShowPasswordPressed;

  const factory SignUpScreenEvent.signUpPressed() = _SignUpPressed;
}
