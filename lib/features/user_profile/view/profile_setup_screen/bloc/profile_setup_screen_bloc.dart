import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/features/user_profile/doamin/entityes/photo_url.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/delete_photo.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/delete_user.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/update_photo.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/update_profile_info.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_event.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_state.dart';

class ProfileSetupBloc
    extends Bloc<ProfileSetupScreenEvent, ProfileSetupScreenState> {
  final UpdateProfileInfoUseCase updateProfileInfo;
  final UpdatePhotoUseCase updatePhoto;
  final DeletePhotoUseCase deletePhotoUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final UserRepository userRepo;
  late StreamSubscription<UserEntity?> subscription;

  ProfileSetupBloc({
    required this.updateProfileInfo,
    required this.updatePhoto,
    required this.deletePhotoUseCase,
    required this.userRepo,
    required this.deleteUserUseCase,
  }) :super(ProfileSetupScreenState(currentInfo: userRepo.userData!)) {
    on<ProfileSetupScreenEvent>(
      (event, emit) async {
        await event.map(statusChanged: (statusChanged) {
          emit(state.copyWith(newStatus: statusChanged.newStatus));
        }, bioChanged: (bioChanged) {
          emit(state.copyWith(newBio: bioChanged.newBio));
        }, photoChanged: (photoChanged) {
          final newPhotoUrl = PhotoUrl.file(photoChanged.imagePath);
          emit(state.copyWith(newPhoto: newPhotoUrl));
        }, deletePhotoPressed: (deletePhotoPressed) {
          emit(state.copyWith(newPhoto: PhotoUrl(source: PhotoSource.deleted)));
        }, updateCurrentInfo: (updateCurrentInfo) {
          emit(state.copyWith(currentInfo: updateCurrentInfo.userEntity));
        }, saveChangesPressed: (saveChangesPressed) async {
          emit(state.copyWith(saveChangesButtonState: ButtonState.loading));
          final profileInfoResult = await updateProfileInfo(UpdateProfileParams(
            newStatus: state.newStatus,
            newBio: state.newBio,
          ));
          profileInfoResult.fold(
            (l) => emit(state.copyWith(error: l)),
            (r) => null,
          );
          final photoUpdateResult = switch (state.newPhoto.source) {
            PhotoSource.deleted => await deletePhotoUseCase(),
            PhotoSource.file => await updatePhoto(state.newPhoto.link!),
            _ => null,
          };
          photoUpdateResult?.fold(
            (l) => emit(state.copyWith(error: l)),
            (r) => null,
          );
          if (state.error == null) {
            emit(state.copyWith(updateCompleted: true));
            add(ProfileSetupScreenEvent.defaultState());
          } else {
            emit(state.copyWith(error: null));
          }
        }, defaultState: (defaultState) {
          emit(ProfileSetupScreenState(
            currentInfo: state.currentInfo,
            newPhoto: state.currentInfo.avatarUrl.isNotEmpty
                ? PhotoUrl.network(state.currentInfo.avatarUrl)
                : PhotoUrl.none(),
          ));
        }, deleteAccountPressed: (deleteAccountPressed) async {
          final result = await deleteUserUseCase();
          result.fold(
            (l) {
              emit(state.copyWith(error: l));
              emit(state.copyWith(error: null));
            },
            (r) => null,
          );
        });
      },
    );
    subscription = userRepo.userSubject.listen((value) {
      if (value != null) {
        add(ProfileSetupScreenEvent.updateCurrentInfo(value));
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
