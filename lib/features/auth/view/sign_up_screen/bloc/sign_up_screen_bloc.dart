import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/constants/regular_expresions.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/features/auth/domain/entity/registration_entity.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_up.dart';
import 'package:social_app/features/auth/view/sign_up_screen/bloc/sign_up_screen_event.dart';
import 'package:social_app/features/auth/view/sign_up_screen/bloc/sign_up_screen_state.dart';
import 'package:social_app/locales/strings.dart';

class SignUpBloc extends Bloc<SignUpScreenEvent, SignUpScreenState> {
  final SignUpUseCase signUpUseCase;

  final RegExp _emailRegEx = RegExp(RegularExpressions.emailRegEx);
  final RegExp _passwordRegEx = RegExp(RegularExpressions.passwordRegEx);
  final RegExp _nicknameRegEx = RegExp(RegularExpressions.nicknameRegEx);

  SignUpBloc({
    required this.signUpUseCase,
  }) : super(const SignUpScreenState()) {
    on<SignUpScreenEvent>((event, emit) async {
      await event.map(
        resetState: (resetState) {
          emit(const SignUpScreenState());
        },
        emailFieldChanged: (emailFieldChanged) {
          emit(state.copyWith(email: emailFieldChanged.newValue));
          _validateEmail(emit);
          _solveButtonState(emit);
        },
        nicknameFieldChanged: (nicknameFieldChanged) {
          emit(state.copyWith(nickname: nicknameFieldChanged.newValue));
          _validateNickname(emit);
          _solveButtonState(emit);
        },
        passwordFieldChanged: (passwordFieldChanged) {
          emit(state.copyWith(
            password: passwordFieldChanged.newValue,
          ));
          _validatePassword(emit);
          if (state.repeatPassword.isNotEmpty) {
            _validateRepeatPassword(emit);
          }
          _solveButtonState(emit);
        },
        repeatPasswordFieldChanged: (repeatPasswordFieldChanged) {
          emit(state.copyWith(
            repeatPassword: repeatPasswordFieldChanged.newValue,
          ));
          _validateRepeatPassword(emit);
          _solveButtonState(emit);
        },
        showPasswordPressed: (showPasswordPressed) {
          emit(state.copyWith(showPassword: !state.showPassword));
        },
        signUpPressed: (signUpPressed) async {
          final emailValidation = _validateEmail(emit);
          final nicknameValidation = _validateNickname(emit);
          final passwordValidation = _validatePassword(emit);
          final repeatedCorrectly = _validateRepeatPassword(emit);
          print('$emailValidation, $passwordValidation, $repeatedCorrectly');
          if (emailValidation &&
              passwordValidation &&
              repeatedCorrectly &&
              nicknameValidation) {
            emit(state.copyWith(buttonState: ButtonState.loading));
            final result = await signUpUseCase(
              RegistrationEntity(
                password: state.password,
                email: state.email,
                nickname: state.nickname,
              ),
            );
            result.fold((l) {
              emit(state.copyWith(
                buttonState: ButtonState.inactive,
                failure: l,
              ));
              emit(state.copyWith(failure: null));
            }, (r) {
              emit(state.copyWith(buttonState: ButtonState.active));
            });
          }
        },
      );
    });
  }

  bool _validateEmail(Emitter<SignUpScreenState> emit) {
    if (_emailRegEx.hasMatch(state.email)) {
      emit(state.copyWith(emailValidationError: null));
      return true;
    } else {
      emit(state.copyWith(emailValidationError: Strings.invalidEmailFormat));
      return false;
    }
  }

  bool _validateNickname(Emitter<SignUpScreenState> emit) {
    if (_nicknameRegEx.hasMatch(state.nickname)) {
      emit(state.copyWith(nicknameValidationError: null));
      return true;
    } else {
      emit(state.copyWith(
          nicknameValidationError: Strings.invalidNicknameFormat));
      return false;
    }
  }

  bool _validatePassword(Emitter<SignUpScreenState> emit) {
    if (_passwordRegEx.hasMatch(state.password)) {
      emit(state.copyWith(passwordValidationError: null));
      return true;
    } else {
      emit(state.copyWith(
          passwordValidationError: Strings.invalidPasswordFormat));
      return false;
    }
  }

  bool _validateRepeatPassword(Emitter<SignUpScreenState> emit) {
    if (state.password == state.repeatPassword) {
      emit(state.copyWith(repeatPasswordValidationError: null));
      return true;
    } else {
      emit(state.copyWith(
          repeatPasswordValidationError: Strings.passwordsDoNotMatch));
      return false;
    }
  }

  void _solveButtonState(Emitter<SignUpScreenState> emit) {
    if (state.emailValidationError != null ||
        state.passwordValidationError != null ||
        state.repeatPasswordValidationError != null) {
      emit(state.copyWith(buttonState: ButtonState.inactive));
    } else {
      emit(state.copyWith(buttonState: ButtonState.active));
    }
  }
}
