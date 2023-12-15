import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_out.dart';

import '../../domain/entity/auth_status.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Duration debounceDuration = const Duration(seconds: 1);

  final AuthRepository authRepository;
  final SignOutUseCase signOutUseCase;

  StreamSubscription<AuthStatus>? _statusSubscription;

  AuthBloc({
    required this.authRepository,
    required this.signOutUseCase,
  }) : super(const AuthState()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        statusChanged: (statusChanged) {
          emit(state.copyWith(authStatus: statusChanged.newStatus));
        },
        loginWithCredentials: (loginWithCredentials) {},
        logOut: (logOut) async {
          await signOutUseCase(null);
        },
      );
    });
    _statusSubscription = authRepository.statusStream
        .debounceTime(debounceDuration)
        .listen((newStatus) {
      add(AuthEvent.statusChanged(newStatus));
    });
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
