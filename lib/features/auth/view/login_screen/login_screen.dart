import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/core/view/widgets/textfield_with_validation.dart';
import 'package:social_app/features/auth/view/login_screen/bloc/login_screen_bloc.dart';
import 'package:social_app/features/auth/view/login_screen/bloc/login_screen_event.dart';
import 'package:social_app/features/auth/view/login_screen/bloc/login_screen_state.dart';
import 'package:social_app/navigation/app_router.dart';

import '../../../../locales/strings.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginScreenBloc>();
    return BlocConsumer<LoginScreenBloc, LoginScreenState>(
        bloc: loginBloc,
        listenWhen: (previous, current) {
          return current.authFailure != null;
        },
        listener: (context, state) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(state.authFailure!.name),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.popRoute();
                      },
                      child: Text(Strings.ok),
                    ),
                  ],
                );
              });
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'APP LOGO HERE!',
                  style: TextStyle(
                    fontSize: 32.0,
                  ),
                ),
                TextFieldWithValidation(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  hint: Strings.emailHint,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  errorText: state.emailValidationError,
                  onChanged: (text) {
                    loginBloc.add(LoginScreenEvent.emailChanged(text));
                  },
                  onSubmitted: (text) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFieldWithValidation(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  hint: Strings.passwordHint,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: state.showPassword,
                  errorText: state.passwordValidationError,
                  trailingWidget: TextButton(
                    onPressed: () {
                      loginBloc.add(LoginScreenEvent.showPasswordPressed());
                    },
                    child: Icon(
                      state.showPassword
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                    ),
                  ),
                  onChanged: (text) {
                    loginBloc.add(LoginScreenEvent.passwordChanged(text));
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (state.signInButtonState != ButtonState.loading) {
                        context.pushRoute(ResetPasswordRoute());
                      }
                    },
                    child: Text(
                      Strings.forgotPassword,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                GeneralButton(
                  buttonState: state.signInButtonState,
                  onPress: () {
                    FocusScope.of(context).unfocus();
                    loginBloc.add(const LoginScreenEvent.signInAttempt());
                  },
                  child: Text(Strings.signIn),
                ),
                GeneralButton(
                  onPress: () {
                    if (state.signInButtonState != ButtonState.loading) {
                      context.pushRoute(const SignUpRoute());
                    }
                  },
                  child: Text(Strings.signUp),
                ),
              ],
            ),
          );
        });
  }
}
