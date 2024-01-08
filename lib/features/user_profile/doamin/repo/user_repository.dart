import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

abstract class UserRepository {
  ///Subject probably still need so repo can sent some signals on user update
  BehaviorSubject<UserEntity?> userSubject = BehaviorSubject();
  late StreamSubscription<UserEntity?> _userSubscription;
  UserEntity? _userInfo;

  UserRepository() {
    _userSubscription = userSubject.listen((value) {
      _userInfo = value;
    });
  }

  UserEntity? get userData => _userInfo;

  Future<Either<Failure, bool>> updateUserData(
    String? avatarPath,
    String? newStatus,
    String? newBio,
  );

  void close() {
    _userSubscription.cancel();
    userSubject.close();
  }
}
