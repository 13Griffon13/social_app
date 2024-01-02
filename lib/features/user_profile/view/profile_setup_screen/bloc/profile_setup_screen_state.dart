import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

part 'profile_setup_screen_state.freezed.dart';

@freezed
class ProfileSetupScreenState with _$ProfileSetupScreenState {
  const factory ProfileSetupScreenState({
    UserEntity? currentInfo,
    @Default('') String newStatus,
    @Default('') String newBio,
    @Default('') String newPhoto,
    Failure? error,
    @Default(false) bool updateCompleted,
  }) = _ProfileSetupScreenState;
}
