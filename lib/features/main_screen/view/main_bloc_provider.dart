import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/di_container.dart';
import 'package:social_app/features/main_screen/view/main_screen/bloc/main_screen_bloc.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/delete_photo.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/delete_user.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/update_photo.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/update_profile_info.dart';
import 'package:social_app/features/user_profile/view/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';

@RoutePage(name: 'MainScreenBlocProviderRoute')
class MainScreenBlocProvider extends StatelessWidget
    implements AutoRouteWrapper {
  const MainScreenBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainScreenBloc()),
        BlocProvider(
          create: (context) => ProfileScreenBloc(
            userRepository: getIt.get<UserRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileSetupBloc(
            updateProfileInfo: getIt.get<UpdateProfileInfoUseCase>(),
            updatePhoto: getIt.get<UpdatePhotoUseCase>(),
            deletePhotoUseCase: getIt.get<DeletePhotoUseCase>(),
            userRepo: getIt.get<UserRepository>(),
            deleteUserUseCase: getIt.get<DeleteUserUseCase>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
