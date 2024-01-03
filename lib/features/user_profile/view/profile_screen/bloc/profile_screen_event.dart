import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

part 'profile_screen_event.freezed.dart';

@freezed
class ProfileScreenEvent with _$ProfileScreenEvent {
  const ProfileScreenEvent._();

  const factory ProfileScreenEvent.userDataUpdated(UserEntity userEntity) = _UserDataUpdated;


}