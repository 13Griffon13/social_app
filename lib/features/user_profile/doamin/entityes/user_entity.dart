import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {

  const factory UserEntity({
    required String id,
    required String email,
    required String name,
    @Default('') String avatarUrl,
    @Default('') String status,
    @Default('') String bio,
  }) = _UserEntity;

}