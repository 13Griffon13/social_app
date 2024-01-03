import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }) : super(const ProfileSetupScreenState()) {
    on<ProfileSetupScreenEvent>(
      (event, emit) async {
        await event.map(
          statusChanged: (statusChanged) {
            emit(state.copyWith(newStatus: statusChanged.newStatus));
          },
          bioChanged: (bioChanged) {
            emit(state.copyWith(newBio: bioChanged.newBio));
          },
          photoChanged: (photoChanged) {},
          saveChangesPressed: (saveChangesPressed) async {
            if (state.currentInfo != null) {
              final result = await updateProfileInfo(
                state.currentInfo!.copyWith(
                  status: state.newStatus,
                  bio: state.newBio,
                  avatarUrl: state.newPhoto,
                ),
              );
              result.fold(
                (l) {
                  emit(state.copyWith(error: l));
                },
                (r) {
                  emit(state.copyWith(updateCompleted: true));
                  emit(state.copyWith(updateCompleted: false));
                },
              );
            }
          },
          updateCurrentInfo: (updateCurrentInfo) {
            if (updateCurrentInfo.userEntity == null) {
              emit(state.copyWith(
                  error: Failure(name: Strings.userMissingError)));
              emit(state.copyWith(error: Failure(name: '')));
            } else {
              emit(
                state.copyWith(
                  currentInfo: updateCurrentInfo.userEntity,
                  newPhoto: updateCurrentInfo.userEntity!.avatarUrl,
                  newStatus: updateCurrentInfo.userEntity!.status,
                  newBio: updateCurrentInfo.userEntity!.bio,
                ),
              );
            }
          },
        );
      },
    );
    subscription = userRepo.userSubject.listen((value) {
      add(ProfileSetupScreenEvent.updateCurrentInfo(value));
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
