import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/view/widgets/user_avatar.dart';
import 'package:social_app/features/user_profile/view/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:social_app/features/user_profile/view/profile_screen/bloc/profile_screen_state.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
        builder: (context, state) {
      if (state.userEntity != null) {
        final userData = state.userEntity!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        flex: 1,
                        child: UserAvatar(
                          radius: 50.0,
                          userNickname: userData.name,
                          avatarUrl: userData.avatarUrl,
                        )),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            userData.name,
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                          Text(
                            userData.status,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: userData.bio.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(4.0),
                        constraints: BoxConstraints(
                          minHeight: 60.0,
                          maxHeight: 240.0,
                          minWidth: double.infinity,
                        ),
                        child: Text(
                          userData.bio,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
              ),
              Flexible(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 20,
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        child: Container(
                          width: 400.0,
                          height: 400.0,
                          color: Colors.purple,
                          alignment: Alignment.center,
                          child: Text('''Post Placeholder
                          $item''',
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
