import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/view/auth_bloc/auth_bloc.dart';
import 'package:social_app/features/auth/view/auth_bloc/auth_event.dart';
import 'package:social_app/locales/strings.dart';
import 'package:social_app/navigation/app_router.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: Text(Strings.editProfile),
            onTap: () {
              context.pushRoute(ProfileSetupRoute());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(Strings.signOut),
            onTap: () {
              context.read<AuthBloc>().add(const AuthEvent.logOut());
            },
          ),
        ],
      ),
    );
  }
}
