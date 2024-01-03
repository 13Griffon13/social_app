import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';

abstract class UserRepository{

  ///TODO something fishy here

  BehaviorSubject<UserEntity?> userSubject = BehaviorSubject();

  Future<UserEntity?> get userData => userSubject.first;

  Future<Either<Failure, bool>> updateUserData(UserEntity userEntity);

  void close();
}