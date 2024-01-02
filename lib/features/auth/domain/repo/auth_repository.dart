import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/auth/domain/entity/registration_entity.dart';
import 'package:social_app/features/auth/domain/entity/user_credentials.dart';

import '../entity/auth_status.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get statusStream;

  Future<Either<Failure, bool>> logInWithCredentials(
      UserCredentials credentials);

  Future<Either<Failure, bool>> signUp(
      RegistrationEntity registrationData);

  Future<Either<Failure, bool>> logOut();

  Future<Either<Failure, bool>> requestPasswordReset(String email);

  Future<Either<Failure, bool>> resetPassword(String code, String newPassword);

  void close();
}
