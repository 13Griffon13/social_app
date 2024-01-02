import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/core/domain/entities/failure.dart';

part 'sign_up_screen_state.freezed.dart';

@freezed
class SignUpScreenState with _$SignUpScreenState {
  const factory SignUpScreenState({
    @Default('') String email,
    String? emailValidationError,
    @Default('') String nickname,
    String? nicknameValidationError,
    @Default('') String password,
    String? passwordValidationError,
    @Default('') String repeatPassword,
    String? repeatPasswordValidationError,
    @Default(ButtonState.active) ButtonState buttonState,
    Failure? failure,
    @Default(false) bool successfullySignedUp,
    @Default(true) bool showPassword,
  }) = _SignUpScreenState;
}
