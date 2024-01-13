import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/core/view/widgets/user_avatar.dart';
import 'package:social_app/features/picture_picker/view/picker_selection_dialog.dart';
import 'package:social_app/features/user_profile/doamin/entityes/photo_url.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_event.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/bloc/profile_setup_screen_state.dart';
import 'package:social_app/features/user_profile/view/profile_setup_screen/delete_confirmation_popup.dart';
import 'package:social_app/locales/strings.dart';
import 'package:social_app/navigation/app_router.dart';

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
    _bioController.text = profileSetupBloc.state.currentInfo.bio;
    _statusController.text = profileSetupBloc.state.currentInfo.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ProfileSetupBloc, ProfileSetupScreenState>(
        bloc: profileSetupBloc,
        listenWhen: (prev, cur) {
          return cur.updateCompleted;
        },
        listener: (context, state) {
          if (state.updateCompleted) {
            context.navigateTo(ProfileRoute());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  switch (state.newPhoto.source) {
                    PhotoSource.network => UserAvatar(
                        userNickname: state.currentInfo.name,
                        avatarUrl: state.currentInfo.avatarUrl,
                        radius: 70.0,
                      ),
                    PhotoSource.file => CircleAvatar(
                        radius: 80.0,
                        backgroundImage: FileImage(File(state.newPhoto.link!)),
                      ),
                    _ => UserAvatar(
                        userNickname: state.currentInfo.name,
                        avatarUrl: '',
                        radius: 70.0,
                      ),
                  },
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return PickerSelector(
                            onPhotoSelected: (imagePath) {
                              profileSetupBloc.add(
                                ProfileSetupScreenEvent.photoChanged(imagePath),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Text(Strings.changePicture),
                  ),
                  Offstage(
                    offstage: state.newPhoto.source == PhotoSource.none ||
                        state.newPhoto.source == PhotoSource.deleted,
                    child: TextButton(
                      onPressed: () {
                        profileSetupBloc.add(
                          ProfileSetupScreenEvent.deletePhotoPressed(),
                        );
                      },
                      child: Text(Strings.deletePhoto),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
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
                    buttonState: state.saveChangesButtonState,
                    child: Text(Strings.saveChanges),
                    onPress: () {
                      profileSetupBloc
                          .add(ProfileSetupScreenEvent.saveChangesPressed());
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteConfirmationPopUp(
                          onAccept: () {
                            profileSetupBloc.add(
                                ProfileSetupScreenEvent.deleteAccountPressed());
                          },
                        ),
                      );
                    },
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

  @override
  void dispose() {
    profileSetupBloc.add(ProfileSetupScreenEvent.defaultState());
    super.dispose();
  }
}
