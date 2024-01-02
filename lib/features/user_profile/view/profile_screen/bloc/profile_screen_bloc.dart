import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';
import 'package:social_app/features/user_profile/view/profile_screen/bloc/profile_screen_event.dart';
import 'package:social_app/features/user_profile/view/profile_screen/bloc/profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  UserRepository userRepository;
  late StreamSubscription<UserEntity?> userUpdateSubscription;

  ///TODO something need to be done with default state or user repo returns
  ProfileScreenBloc({
    required this.userRepository,
  }) : super(ProfileScreenState(userEntity: null)) {
    on<ProfileScreenEvent>((event, emit) async {
      event.map(
        userDataUpdated: (userDataUpdated) {
          emit(state.copyWith(userEntity: userDataUpdated.userEntity));
        },
      );
    });
    userUpdateSubscription = userRepository.userSubject.listen(
      (value) {
        if (value != null) {
          add(ProfileScreenEvent.userDataUpdated(value));
        }
      },
    );
  }

  @override
  Future<void> close() {
    userUpdateSubscription.cancel();
    return super.close();
  }
}
