import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/main_screen/view/main_screen/bloc/main_screen_bloc.dart';

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
      ],
      child: this,
    );
  }
}
