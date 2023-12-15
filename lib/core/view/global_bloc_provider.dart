import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/di_container.dart';
import 'package:social_app/features/auth/data/repo_impl/firebase_auth_repository.dart';
import 'package:social_app/features/auth/domain/entity/auth_status.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_out.dart';
import 'package:social_app/navigation/app_router.dart';

import '../../features/auth/view/auth_bloc/auth_bloc.dart';
import '../../features/auth/view/auth_bloc/auth_state.dart';

@RoutePage(name: 'GlobalBlocProviderRoute')
class GlobalBlocProvider extends StatelessWidget implements AutoRouteWrapper {
  const GlobalBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: getIt.get<FirebaseAuthRepository>(),
            signOutUseCase: getIt.get<SignOutUseCase>(),
          ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            switch (state.authStatus) {
              case AuthStatus.signedIn:
                context.replaceRoute(const MainScreenBlocProviderRoute());
                break;
              case AuthStatus.signedOut:
                context.replaceRoute(const AuthBlocProviderRoute());
                break;
              case AuthStatus.unknown:
                context.replaceRoute(const SplashRoute());
                break;
            }
          },
          child: this),
    );
  }
}
