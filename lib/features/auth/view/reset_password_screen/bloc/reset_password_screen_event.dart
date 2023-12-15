import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_screen_event.freezed.dart';

@freezed
class ResetPasswordScreenEvent with _$ResetPasswordScreenEvent {
  const ResetPasswordScreenEvent._();

  const factory ResetPasswordScreenEvent.emailFieldChanged(
      {required String newData}) = _EmailFieldChangedt;

  const factory ResetPasswordScreenEvent.sendCodePressed() = _SendCodePressed;

  const factory ResetPasswordScreenEvent.toBaseState() =_ToBaseState;
}
