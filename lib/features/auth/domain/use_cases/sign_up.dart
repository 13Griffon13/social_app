import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';
import 'package:social_app/features/auth/domain/entity/user_credentials.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';

class SignUpUseCase extends UseCase<bool,UserCredentials>{
  AuthRepository authRepository;

  SignUpUseCase({required this.authRepository,});

  @override
  Future<Either<Failure, bool>> call(UserCredentials params) async{
    final result = await authRepository.signUp(params);
    return result;
  }

}