import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/auth/domain/entity/user_entity.dart';

abstract class UserRepository{
  UserEntity? user;

  Future<Either<Failure, UserEntity>> getUserData();
}