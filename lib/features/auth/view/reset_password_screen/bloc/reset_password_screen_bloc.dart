import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/core/constants/regular_expresions.dart';
import 'package:social_app/core/domain/button_state.dart';
import 'package:social_app/features/auth/domain/use_cases/request_password_reset.dart';
import 'package:social_app/features/auth/view/reset_password_screen/bloc/reset_password_screen_event.dart';
import 'package:social_app/features/auth/view/reset_password_screen/bloc/reset_password_screen_state.dart';
import 'package:social_app/locales/strings.dart';

class ResetPasswordScreenBloc
    extends Bloc<ResetPasswordScreenEvent, ResetPasswordScreenState> {
  final RequestPasswordResetUseCase requestPasswordResetUseCase;

  final RegExp _emailRegEx = RegExp(RegularExpressions.emailRegEx);

  ResetPasswordScreenBloc({
    required this.requestPasswordResetUseCase,
  }) : super(const ResetPasswordScreenState()) {
    on<ResetPasswordScreenEvent>((event, emit) async {
      await event.map(
        emailFieldChanged: (emailFieldChanged) {
          emit(
            state.copyWith(email: emailFieldChanged.newData),
          );
          _validateEmail(emit);
        },
        sendCodePressed: (sendCodePressed) async {
          if (_validateEmail(emit)) {
            emit(state.copyWith(buttonState: ButtonState.loading));
            final result = await requestPasswordResetUseCase(state.email);
            result.fold(
              (l) {
                emit(state.copyWith(failure: l));
              },
              (r) {
                emit(state.copyWith(codeSent: true));
              },
            );
          }
        },
        toBaseState: (toBaseState){
          emit(const ResetPasswordScreenState());
        }
      );
    });
  }

  bool _validateEmail(Emitter<ResetPasswordScreenState> emit) {
    if (_emailRegEx.hasMatch(state.email)) {
      emit(state.copyWith(
        emailValidationError: null,
        buttonState: ButtonState.active,
      ));
      return true;
    } else {
      emit(state.copyWith(
        emailValidationError: Strings.invalidEmailFormat,
        buttonState: ButtonState.inactive,
      ));
      return false;
    }
  }
}
