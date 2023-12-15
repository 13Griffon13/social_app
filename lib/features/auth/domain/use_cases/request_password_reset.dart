import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';
import 'package:social_app/features/auth/domain/repo/auth_repository.dart';

class RequestPasswordResetUseCase extends UseCase<bool,String>{
  AuthRepository authRepository;

  RequestPasswordResetUseCase({required this.authRepository,});

  @override
  Future<Either<Failure, bool>> call(String params) async{
    return await authRepository.requestPasswordReset(params);
  }

}