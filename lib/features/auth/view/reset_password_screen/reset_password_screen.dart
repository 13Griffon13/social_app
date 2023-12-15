import 'package:auto_route/auto_route.dart';
import 'package:social_app/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/core/view/widgets/textfield_with_validation.dart';
import 'package:social_app/features/auth/view/reset_password_screen/bloc/reset_password_screen_bloc.dart';
import 'package:social_app/features/auth/view/reset_password_screen/bloc/reset_password_screen_event.dart';
import 'package:social_app/features/auth/view/reset_password_screen/bloc/reset_password_screen_state.dart';
import 'package:social_app/locales/strings.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordScreenBloc _resetPasswordScreenBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetPasswordScreenBloc = context.read<ResetPasswordScreenBloc>();
    _resetPasswordScreenBloc.add(ResetPasswordScreenEvent.toBaseState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.resetPassword),
        centerTitle: true,
      ),
      body: BlocConsumer<ResetPasswordScreenBloc, ResetPasswordScreenState>(
        bloc: _resetPasswordScreenBloc,
        listenWhen: (previous, current) {
          return current.codeSent || current.failure != null;
        },
        listener: (context, state) {
          if (state.codeSent) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(Strings.passwordResetSuccess),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.popRoute();
                        context.navigateTo(LoginRoute());
                      },
                      child: Text(Strings.ok),
                    ),
                  ],
                );
              },
            );
          }
          if (state.failure != null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(state.failure!.name),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.popRoute();
                      },
                      child: Text(Strings.ok),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    Strings.resetPasswordInfo,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                TextFieldWithValidation(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  hint: Strings.emailHint,
                  errorText: state.emailValidationError,
                  onChanged: (newData) {
                    _resetPasswordScreenBloc.add(
                      ResetPasswordScreenEvent.emailFieldChanged(
                          newData: newData),
                    );
                  },
                ),
                GeneralButton(
                  child: Text(Strings.resetPassword),
                  buttonState: state.buttonState,
                  onPress: () {
                    FocusScope.of(context).unfocus();
                    _resetPasswordScreenBloc
                        .add(ResetPasswordScreenEvent.sendCodePressed());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
