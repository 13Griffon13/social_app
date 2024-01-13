import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/core/constants/firebase_paths.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/auth/domain/entity/auth_status.dart';
import 'package:social_app/features/auth/domain/entity/registration_entity.dart';
import 'package:social_app/features/auth/domain/entity/user_credentials.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';
import 'package:social_app/features/user_profile/data/model/user_data_model.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final StreamController<AuthStatus> _statusController = StreamController();
  late final StreamSubscription _authStateSubscription;

  FirebaseAuthRepository({
    required this.firebaseAuth,
    required this.firestore,
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
  Future<Either<Failure, bool>> signUp(
      RegistrationEntity registrationData) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: registrationData.email,
        password: registrationData.password,

      );
      firestore
          .collection(FirebasePaths.userDataCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .set(UserDataModel(nickname: registrationData.nickname).toJson());
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

  @override
  void close() {
    _authStateSubscription.cancel();
  }
}
