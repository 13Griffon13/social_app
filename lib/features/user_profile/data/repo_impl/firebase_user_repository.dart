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
      return left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserData(
    String? newStatus,
    String? newBio,
  ) async {
    try {
      final currentUser = userData!;

      await fireStore
          .collection(FirebasePaths.userDataCollection)
          .doc(currentUser.id)
          .update(UserDataModel.fromEntity(
            currentUser.copyWith(
              status: newStatus ?? currentUser.status,
              bio: newBio ?? currentUser.bio,
            ),
          ).toJson());
      return right(true);
    } catch (e) {
      return left(
        Failure.fromException(e),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deletePhoto() async {
    try {
      final currentUser = userData!;
      final storageRef = firebaseStorage.ref();
      print(
          'deleting : ${FirebasePaths.userAvatarFolder(currentUser.id)}/avatar.png');
      await storageRef
          .child('${FirebasePaths.userAvatarFolder(currentUser.id)}/avatar.png')
          .delete();
      await fireStore
          .collection(FirebasePaths.userDataCollection)
          .doc(currentUser.id)
          .update({'profilePicUrl': ''});
      return right(true);
    } catch (e) {
      return left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePhoto(String filePath) async {
    try {
      final currentUser = userData!;
      final newAvatarUrl = await _saveNewAvatar(filePath);
      await fireStore
          .collection(FirebasePaths.userDataCollection)
          .doc(currentUser.id)
          .update({'profilePicUrl': newAvatarUrl});
      return right(true);
    } catch (e) {
      return left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    try {
      final currentUser = userData!;
      final usersStoredData = await firebaseStorage
          .ref()
          .child('users/${currentUser.id}')
          .listAll();
      for (var element in usersStoredData.items) {
        firebaseStorage.ref(element.fullPath).delete();
      }
      await fireStore
          .collection(FirebasePaths.userDataCollection)
          .doc(currentUser.id)
          .delete();
      await firebaseAuth.currentUser!.delete();
      return right(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        final result = await _reauthenticateAndDelete();
        if (result == null) {
          return right(true);
        } else {
          return left(result);
        }
      } else {
        return left(Failure.fromException(e));
      }
    } catch (e) {
      return left(
        Failure.fromException(e),
      );
    }
  }

  Future<Failure?> _reauthenticateAndDelete() async {
    try {
      final providerData = firebaseAuth.currentUser?.providerData.first;
      ///TODO finish implemetnation
      print(providerData!.providerId.toString());
      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }
      await firebaseAuth.currentUser?.delete();
    } catch (e) {
      return Failure.fromException(e);
    }
  }

  Future<String?> _saveNewAvatar(String? filePath) async {
    if (filePath != null) {
      final storageRef = firebaseStorage.ref();
      final avatarRef = storageRef
          .child('${FirebasePaths.userAvatarFolder(userData!.id)}/avatar.png');
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
