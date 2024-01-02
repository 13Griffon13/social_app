import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

part 'user_data_model.freezed.dart';

part 'user_data_model.g.dart';

@freezed
class UserDataModel with _$UserDataModel {
  const UserDataModel._();

  const factory UserDataModel({
    required String nickname,
    @Default('') String profilePicUrl,
    @Default('') String status,
    @Default('') String bio,
    @Default(<String>[]) List<String> friends,
  }) = _UserDataModel;

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  factory UserDataModel.fromEntity(UserEntity userEntity) => UserDataModel(
        nickname: userEntity.name,
        profilePicUrl: userEntity.avatarUrl,
        status: userEntity.status,
        bio: userEntity.bio,
      );
}
