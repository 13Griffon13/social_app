import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/core/domain/entities/failure.dart';

part 'login_screen_state.freezed.dart';

@freezed
class LoginScreenState with _$LoginScreenState {
  const factory LoginScreenState({
    @Default('') String email,
    @Default('') String password,
    @Default(ButtonState.active) ButtonState signInButtonState,
    String? emailValidationError,
    String? passwordValidationError,
    Failure? authFailure,
    @Default(true) bool showPassword,
  }) = _LoginScreenState;
}
