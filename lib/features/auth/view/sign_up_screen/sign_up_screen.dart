import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/view/widgets/error_dialog.dart';
import 'package:social_app/core/view/widgets/general_button.dart';
import 'package:social_app/core/view/widgets/textfield_with_validation.dart';
import 'package:social_app/features/auth/view/sign_up_screen/bloc/sign_up_screen_bloc.dart';
import 'package:social_app/features/auth/view/sign_up_screen/bloc/sign_up_screen_event.dart';
import 'package:social_app/features/auth/view/sign_up_screen/bloc/sign_up_screen_state.dart';
import 'package:social_app/locales/strings.dart';
import 'package:social_app/navigation/app_router.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpBloc _signUpBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _signUpBloc = context.read<SignUpBloc>();
    _signUpBloc.add(SignUpScreenEvent.resetState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.signUp),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<SignUpBloc, SignUpScreenState>(
            bloc: _signUpBloc,
            listenWhen: (previous, current) {
              return current.failure != null;
            },
            listener: (context, state) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ErrorDialog(
                      title: state.failure!.name,
                    );
                  });
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        Strings.signUpInstructions,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    TextFieldWithValidation(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      hint: Strings.emailHint,
                      errorText: state.emailValidationError,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (text) {
                        _signUpBloc.add(SignUpScreenEvent.emailFieldChanged(
                            newValue: text));
                      },
                    ),
                    Text(
                      Strings.nicknameDescription,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    TextFieldWithValidation(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      hint: Strings.nickname,
                      errorText: state.nicknameValidationError,
                      keyboardType: TextInputType.name,
                      onChanged: (text) {
                        _signUpBloc.add(SignUpScreenEvent.nicknameFieldChanged(
                            newValue: text));
                      },
                    ),
                    Text(
                      Strings.passwordCreationInstructions,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    TextFieldWithValidation(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      hint: Strings.passwordHint,
                      errorText: state.passwordValidationError,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: state.showPassword,
                      trailingWidget: TextButton(
                        onPressed: () {
                          _signUpBloc
                              .add(SignUpScreenEvent.showPasswordPressed());
                        },
                        child: Icon(
                          state.showPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                      onChanged: (text) {
                        _signUpBloc.add(
                          SignUpScreenEvent.passwordFieldChanged(
                              newValue: text),
                        );
                      },
                    ),
                    TextFieldWithValidation(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 30.0,
                      ),
                      hint: Strings.repeatPassword,
                      errorText: state.repeatPasswordValidationError,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: state.showPassword,
                      trailingWidget: TextButton(
                        onPressed: () {
                          _signUpBloc
                              .add(SignUpScreenEvent.showPasswordPressed());
                        },
                        child: Icon(
                          state.showPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                        ),
                      ),
                      onChanged: (text) {
                        _signUpBloc.add(
                          SignUpScreenEvent.repeatPasswordFieldChanged(
                              newValue: text),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.termsOfServiceSentence,
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushRoute(TermsAndConditionsRoute());
                          },
                          child: Text(
                            Strings.termsOfServiceButton,
                          ),
                        ),
                      ],
                    ),
                    GeneralButton(
                      buttonState: state.buttonState,
                      onPress: () {
                        _signUpBloc.add(SignUpScreenEvent.signUpPressed());
                      },
                      child: Text(Strings.signUp),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
