import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/core/domain/entities/failure.dart';

part 'reset_password_screen_state.freezed.dart';

@freezed
class ResetPasswordScreenState with _$ResetPasswordScreenState {
  const factory ResetPasswordScreenState({
    @Default('') String email,
    String? emailValidationError,
    @Default(ButtonState.active) ButtonState buttonState,
    Failure? failure,
    @Default(false) bool codeSent,
  }) = _ResetPasswordScreenState;
}
