import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:social_app/features/auth/data/repo_impl/firebase_auth_repository.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';
import 'package:social_app/features/auth/domain/use_cases/request_password_reset.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_out.dart';
import 'package:social_app/features/auth/domain/use_cases/sign_up.dart';
import 'package:social_app/features/user_profile/data/repo_impl/firebase_user_repository.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';
import 'package:social_app/features/user_profile/doamin/use_cases/update_profile_info.dart';

final getIt = GetIt.instance;

void diInit() {
  ///Services
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance,);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  ///*****
  ///Repos
  ///*****

  getIt.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(
      firebaseAuth: getIt.get<FirebaseAuth>(),
      firestore: getIt.get<FirebaseFirestore>(),
    ),
    dispose: (authRepo){
      authRepo.close();
    }
  );
  getIt.registerLazySingleton<UserRepository>(
    () => FirebaseUserRepository(
      firebaseAuth: getIt.get<FirebaseAuth>(),
      fireStore: getIt.get<FirebaseFirestore>(),
    ),
    dispose: (userRepo){
      userRepo.close();
    }
  );

  ///********
  ///UseCases
  ///********

  ///Auth
  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(
      authRepository: getIt.get<AuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(
      authRepository: getIt.get<AuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(
      authRepository: getIt.get<AuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<RequestPasswordResetUseCase>(
    () => RequestPasswordResetUseCase(
      authRepository: getIt.get<AuthRepository>(),
    ),
  );

  ///User_profile
  getIt.registerLazySingleton<UpdateProfileInfoUseCase>(
    () => UpdateProfileInfoUseCase(
      userRepository: getIt.get<UserRepository>(),
    ),
  );
}
