import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:social_app/features/auth/data/repo_impl/firebase_auth_repository.dart';
import 'package:social_app/features/auth/domain/use_cases/request_password_reset.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_out.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_up.dart';

final getIt = GetIt.instance;

void diInit() {
  ///Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  ///*****
  ///Repos
  ///*****

  /// Auth
  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepository(
      firebaseAuth: getIt.get<FirebaseAuth>(),
    ),
  );

  ///********
  ///UseCases
  ///********

  ///Auth
  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(
      authRepository: getIt.get<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(
      authRepository: getIt.get<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(
      authRepository: getIt.get<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<RequestPasswordResetUseCase>(
    () => RequestPasswordResetUseCase(
      authRepository: getIt.get<FirebaseAuthRepository>(),
    ),
  );
}
