import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/core/constants/firestore_collections.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/data/model/user_data_model.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore fireStore;

  late StreamSubscription _authStateSubscription;
  StreamSubscription? _userUpdateSubscription;

  FirebaseUserRepository({
    required this.firebaseAuth,
    required this.fireStore,
  }) {
    _authStateSubscription = firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _userUpdateSubscription = fireStore
            .collection(FirestoreCollections.userDataCollection)
            .doc(firebaseAuth.currentUser!.uid)
            .snapshots()
            .listen(
          (documentSnapshot) {
            if (documentSnapshot.data() != null) {
              loadUser(user, documentSnapshot.data()!);
            }
          },
        );
      } else {
        _userUpdateSubscription?.cancel();
      }
    });
  }

  Future<Either<Failure, UserEntity>> loadUser(
    User user,
    Map<String, dynamic> documentData,
  ) async {
    try {
      final userData = UserDataModel.fromJson(documentData);
      final userEntity = UserEntity(
        id: user.uid,
        email: user.email ?? '',
        name: userData.nickname,
        avatarUrl: userData.profilePicUrl,
        bio: userData.bio,
        status: userData.status,
      );
      userSubject.add(userEntity);
      return right(userEntity);
    } catch (e) {
      return left(Failure(name: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserData(UserEntity userEntity) async {
    try {
      await fireStore
          .collection(FirestoreCollections.userDataCollection)
          .doc(userEntity.id)
          .set(UserDataModel.fromEntity(userEntity).toJson());
      return right(true);
    } catch (e) {
      return left(
        Failure(name: e.runtimeType.toString(), description: e.toString()),
      );
    }
    throw UnimplementedError();
  }

  @override
  void close() {
    _authStateSubscription.cancel();
    _userUpdateSubscription?.cancel();
  }
}
