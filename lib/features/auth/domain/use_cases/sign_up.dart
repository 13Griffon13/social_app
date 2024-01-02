import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';
import 'package:social_app/features/auth/domain/entity/registration_entity.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';

class SignUpUseCase extends UseCase<bool,RegistrationEntity>{
  AuthRepository authRepository;

  SignUpUseCase({required this.authRepository,});

  @override
  Future<Either<Failure, bool>> call(RegistrationEntity params) async{
    final result = await authRepository.signUp(params);
    return result;
  }

}