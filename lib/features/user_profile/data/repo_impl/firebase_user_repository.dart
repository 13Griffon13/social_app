import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/core/constants/firebase_paths.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/data/model/user_data_model.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore fireStore;
  final FirebaseStorage firebaseStorage;

  late StreamSubscription _authStateSubscription;
  StreamSubscription? _userUpdateSubscription;

  FirebaseUserRepository({
    required this.firebaseAuth,
    required this.fireStore,
    required this.firebaseStorage,
  }) {
    _authStateSubscription = firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _userUpdateSubscription = fireStore
            .collection(FirebasePaths.userDataCollection)
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
  Future<Either<Failure, bool>> updateUserData(
    String? avatarPath,
    String? newStatus,
    String? newBio,
  ) async {
    try {
      final currentUser = await userSubject.first;
      final newAvatarUrl = await saveNewAvatar(avatarPath, currentUser!.id);
      await fireStore
          .collection(FirebasePaths.userDataCollection)
          .doc(currentUser.id)
          .set(UserDataModel.fromEntity(
            currentUser.copyWith(
              avatarUrl: newAvatarUrl ?? currentUser.avatarUrl,
              status: newStatus ?? currentUser.status,
              bio: newBio ?? currentUser.bio,
            ),
          ).toJson());
      return right(true);
    } catch (e) {
      return left(
        Failure(name: e.runtimeType.toString(), description: e.toString()),
      );
    }
    throw UnimplementedError();
  }

  Future<String?> saveNewAvatar(String? filePath, String uid) async {
    if (filePath != null) {
      final fileExtension = filePath.split('.').last;
      final storageRef = firebaseStorage.ref();
      final avatarRef = storageRef.child('${FirebasePaths.userAvatarFolder(uid)}/avatar.$fileExtension}');
      await avatarRef.putFile(File(filePath));
      return await avatarRef.getDownloadURL();
    } else {
      return null;
    }
  }

  @override
  void close() {
    _authStateSubscription.cancel();
    _userUpdateSubscription?.cancel();
    super.close();
  }
}
