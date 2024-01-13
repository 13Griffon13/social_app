import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

part 'profile_setup_screen_event.freezed.dart';

@freezed
class ProfileSetupScreenEvent with _$ProfileSetupScreenEvent {
  const ProfileSetupScreenEvent._();

  const factory ProfileSetupScreenEvent.statusChanged(String newStatus) =
      _StatusChanged;

  const factory ProfileSetupScreenEvent.bioChanged(String newBio) = _BioChanged;

  const factory ProfileSetupScreenEvent.photoChanged(String imagePath) =
      _PhotoChanged;

  const factory ProfileSetupScreenEvent.deletePhotoPressed() =
      _DeletePhotoPressed;

  const factory ProfileSetupScreenEvent.deleteAccountPressed() =
  _DeleteAccountPressed;

  const factory ProfileSetupScreenEvent.updateCurrentInfo(
      UserEntity userEntity) = _UpdateurrentInfo;

  const factory ProfileSetupScreenEvent.saveChangesPressed() =
      _SaveChangesPressed;

  const factory ProfileSetupScreenEvent.defaultState() = _DefaultState;
}
