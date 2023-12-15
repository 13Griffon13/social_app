import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_credentials.freezed.dart';

@freezed
class UserCredentials with _$UserCredentials {
  const factory UserCredentials({
    required String password,
    required String email,
  }) = _UserCredentials;

}