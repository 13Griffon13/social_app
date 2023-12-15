import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/constants/regular_expresions.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/features/auth/domain/entity/user_credentials.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:social_app/features/auth/view/login_screen/bloc/login_screen_event.dart';
import 'package:social_app/features/auth/view/login_screen/bloc/login_screen_state.dart';
import 'package:social_app/locales/strings.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final SignInUseCase signInUseCase;

  final RegExp _emailRegEx = RegExp(RegularExpressions.emailRegEx);
  final RegExp _passwordRegEx = RegExp(RegularExpressions.passwordRegEx);

  LoginScreenBloc({
    required this.signInUseCase,
  }) : super(const LoginScreenState()) {
    on<LoginScreenEvent>(
      (event, emit) async {
        await event.map(
          emailChanged: (emailChanged) {
            emit(state.copyWith(email: emailChanged.newValue));
            _validateEmail(emit);
            if (state.passwordValidationError == null &&
                state.emailValidationError == null) {
              emit(state.copyWith(signInButtonState: ButtonState.active));
            }
          },
          passwordChanged: (passwordChanged) {
            emit(state.copyWith(password: passwordChanged.newValue));
            _validatePassword(emit);
            if (state.passwordValidationError == null &&
                state.emailValidationError == null) {
              emit(state.copyWith(signInButtonState: ButtonState.active));
            }
          },
          signInAttempt: (signInAttempt) async {
            final emailValid = _validateEmail(emit);
            final passwordValid = _validatePassword(emit);
            emit(state.copyWith(
              signInButtonState: ButtonState.loading,
            ));
            if (passwordValid && emailValid) {
              final result = await signInUseCase(
                UserCredentials(
                  password: state.password,
                  email: state.email,
                ),
              );
              result.fold(
                (l) {
                  emit(state.copyWith(authFailure: l));
                  emit(state.copyWith(authFailure: null));
                },
                (r) {},
              );
              emit(state.copyWith(
                signInButtonState: ButtonState.active,
              ));
            } else {
              emit(
                state.copyWith(signInButtonState: ButtonState.inactive),
              );
            }
          },
          showPasswordPressed: (showPasswordPressed) {
            emit(state.copyWith(showPassword: !state.showPassword));
          },
        );
      },
    );
  }

  bool _validateEmail(Emitter<LoginScreenState> emit) {
    if (_emailRegEx.hasMatch(state.email)) {
      emit(state.copyWith(emailValidationError: null));
    } else {
      emit(state.copyWith(emailValidationError: Strings.invalidEmailFormat));
    }
    return _emailRegEx.hasMatch(state.email);
  }

  bool _validatePassword(Emitter<LoginScreenState> emit) {
    if (_passwordRegEx.hasMatch(state.password)) {
      emit(state.copyWith(passwordValidationError: null));
    } else {
      emit(state.copyWith(
          passwordValidationError: Strings.invalidPasswordFormat));
    }
    return _passwordRegEx.hasMatch(state.password);
  }
}
