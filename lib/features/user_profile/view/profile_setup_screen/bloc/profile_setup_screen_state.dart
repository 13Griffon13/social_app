import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/doamin/entityes/photo_url.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

part 'profile_setup_screen_state.freezed.dart';


@freezed
class ProfileSetupScreenState with _$ProfileSetupScreenState {
  const factory ProfileSetupScreenState({
    required UserEntity currentInfo,
    String? newStatus,
    String? newBio,
    @Default(PhotoUrl(source: PhotoSource.none)) PhotoUrl newPhoto,
    @Default(ButtonState.active) ButtonState saveChangesButtonState,
    Failure? error,
    @Default(false) bool updateCompleted,
  }) = _ProfileSetupScreenState;
}
