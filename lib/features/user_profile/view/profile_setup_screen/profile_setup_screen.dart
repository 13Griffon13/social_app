import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_event.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_state.dart';
import 'package:social_app/locales/strings.dart';

@RoutePage()
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {

  late final ProfileSetupBloc profileSetupBloc;

  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileSetupBloc = context.read<ProfileSetupBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupScreenState>(
        bloc: profileSetupBloc,
        listener: (context, state){
          if(state.updateCompleted){
            context.popRoute();
          }
        },
        buildWhen: (prev, cur){
          return cur.currentInfo != prev.currentInfo;
        },
        builder: (context, state) {
          _statusController.text = state.newStatus;
          _bioController.text = state.newBio;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(Strings.changePicture),
                  ),
                  TextField(
                    onChanged: (newText) {
                      profileSetupBloc
                          .add(ProfileSetupScreenEvent.statusChanged(newText));
                    },
                    controller: _statusController,
                    maxLength: 120,
                    minLines: 3,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: Strings.status,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: Strings.statusHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (newText) {
                      profileSetupBloc
                          .add(ProfileSetupScreenEvent.bioChanged(newText));
                    },
                    controller: _bioController,
                    maxLength: 500,
                    minLines: 6,
                    maxLines: 14,
                    decoration: InputDecoration(
                      labelText: Strings.bio,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: Strings.bioHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  GeneralButton(
                    child: Text(Strings.saveChanges),
                    onPress: () {
                      profileSetupBloc
                          .add(ProfileSetupScreenEvent.saveChangesPressed());
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(Strings.deleteProfile),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
