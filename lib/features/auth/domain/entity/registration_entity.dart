import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_entity.freezed.dart';

@freezed
class RegistrationEntity with _$RegistrationEntity {
  const factory RegistrationEntity({
    required String email,
    required String password,
    required String nickname,
  }) = _RegistrationEntity;

}