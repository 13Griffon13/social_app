import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/features/auth/domain/entity/auth_status.dart';
import 'package:social_app/features/auth/domain/entity/user_credentials.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const AuthEvent._();

  const factory AuthEvent.statusChanged(AuthStatus newStatus) = _StatusChanged;

  const factory AuthEvent.loginWithCredentials(UserCredentials credentials) =
      _LoginWithCredentials;

  const factory AuthEvent.logOut() = _LogOut;
}
