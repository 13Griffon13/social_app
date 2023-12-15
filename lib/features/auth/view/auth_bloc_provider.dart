import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/di_container.dart';
import 'package:social_app/features/auth/domain/use_cases/request_password_reset.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_up.dart';
import 'package:social_app/features/auth/view/login_screen/bloc/login_screen_bloc.dart';
import 'package:social_app/features/auth/view/reset_password_screen/bloc/reset_password_screen_bloc.dart';
import 'package:social_app/features/auth/view/sign_up_screen/bloc/sign_up_screen_bloc.dart';

@RoutePage(name: 'AuthBlocProviderRoute')
class AuthBlocProvider extends StatelessWidget implements AutoRouteWrapper {
  const AuthBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginScreenBloc(
            signInUseCase: getIt.get<SignInUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(
            signUpUseCase: getIt.get<SignUpUseCase>(),
          ),
        ),
        BlocProvider(create: (context) => ResetPasswordScreenBloc(
          requestPasswordResetUseCase: getIt.get<RequestPasswordResetUseCase>(),
        ),),
      ],
      child: this,
    );
  }
}
