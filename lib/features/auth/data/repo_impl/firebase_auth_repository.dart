import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/auth/domain/entity/auth_status.dart';
import 'package:social_app/features/auth/domain/entity/user_credentials.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth firebaseAuth;
  final StreamController<AuthStatus> _statusController = StreamController();
  late final StreamSubscription _authStateSubscription;

  FirebaseAuthRepository({
    required this.firebaseAuth,
  }) {
    _authStateSubscription = firebaseAuth.authStateChanges().listen((event) {
      if (event != null) {
        _statusController.add(AuthStatus.signedIn);
      } else {
        _statusController.add(AuthStatus.signedOut);
      }
    });
  }

  @override
  Future<Either<Failure, bool>> logInWithCredentials(
      UserCredentials credentials) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: credentials.email, password: credentials.password);
      return right(result.user != null);
    } catch (e) {
      return left(Failure(
        name: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      await firebaseAuth.signOut();
      return right(true);
    } catch (e) {
      return left(Failure(name: e.toString()));
    }
  }

  @override
  Stream<AuthStatus> get statusStream => _statusController.stream;

  @override
  Future<Either<Failure, bool>> signUp(UserCredentials credentials) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      );
      return right(result.user != null);
    } catch (e) {
      return left(Failure(
        name: e.toString(),
      ));
    }
  }

  void dispose() {
    _authStateSubscription.cancel();
    _statusController.close();
  }

  @override
  Future<Either<Failure, bool>> requestPasswordReset(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return right(true);
    } catch (e) {
      return left(Failure(
        name: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
      String code, String newPassword) async {
    try {
      print('$code $newPassword');
      await firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
      print('reset password sent');
      return right(true);
    } catch (e) {
      return left(Failure(
        name: e.toString(),
      ));
    }
  }
}
