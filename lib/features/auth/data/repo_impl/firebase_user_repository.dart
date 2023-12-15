import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/features/auth/domain/entity/user_entity.dart';
import 'package:social_app/features/auth/domain/repo/user_repository.dart';

class FirebaseUserRepository extends UserRepository{
  @override
  Future<Either<Failure, UserEntity>> getUserData() {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

}