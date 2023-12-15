import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/features/auth/view/auth_bloc/auth_bloc.dart';
import 'package:social_app/features/auth/view/auth_bloc/auth_event.dart';

import '../../../../locales/strings.dart';
import 'bloc/main_screen_bloc.dart';
import 'bloc/main_screen_state.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.appName,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<MainScreenBloc, MainScreenState>(
        bloc: bloc,
        listener: (context, state) {

        },
        builder: (context, state) {
          return Center(
            child: GeneralButton(
              onPress: (){
                context.read<AuthBloc>().add(const AuthEvent.logOut());
              },
              child: const Text('TMP Sign Out'),
            ),
          );
        },
      ),
    );
  }
}
