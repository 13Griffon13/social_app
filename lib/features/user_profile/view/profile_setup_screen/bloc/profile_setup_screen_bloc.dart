import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/update_profile_info.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_event.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_state.dart';
import 'package:social_app/locales/strings.dart';

class ProfileSetupBloc
    extends Bloc<ProfileSetupScreenEvent, ProfileSetupScreenState> {
  final UpdateProfileInfoUseCase updateProfileInfo;
  final UserRepository userRepo;
  late StreamSubscription<UserEntity?> subscription;

  ProfileSetupBloc({
    required this.updateProfileInfo,
    required this.userRepo,
  }) :

        ///TODO not sure about this nullable
        super(ProfileSetupScreenState(currentInfo: userRepo.userData!)) {
    on<ProfileSetupScreenEvent>(
      (event, emit) async {
        await event.map(
          statusChanged: (statusChanged) {
            emit(state.copyWith(newStatus: statusChanged.newStatus));
          },
          bioChanged: (bioChanged) {
            emit(state.copyWith(newBio: bioChanged.newBio));
          },
          photoChanged: (photoChanged) {
            emit(state.copyWith(newPhoto: photoChanged.imagePath));
          },
          updateCurrentInfo: (updateCurrentInfo) {
            emit(state.copyWith(currentInfo: updateCurrentInfo.userEntity));
            add(ProfileSetupScreenEvent.defaultState());
          },
          saveChangesPressed: (saveChangesPressed) async {
            emit(state.copyWith(saveChangesButtonState: ButtonState.loading));
            final result = await updateProfileInfo(Params(
              newAvatarPath: state.newPhoto,
              newStatus: state.newStatus,
              newBio: state.newBio,
            ));
            result.fold(
              (l) {
                emit(state.copyWith(error: l));
                emit(state.copyWith(error: null));
              },
              (r) {
                emit(state.copyWith(updateCompleted: true));
                add(ProfileSetupScreenEvent.defaultState());
              },
            );
            emit(state.copyWith(saveChangesButtonState: ButtonState.active));
          },
          defaultState: (defaultState) {
            emit(ProfileSetupScreenState(currentInfo: state.currentInfo));
          },
        );
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
