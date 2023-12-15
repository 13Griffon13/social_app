import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';

import '../repo/auth_repository.dart';

class SignOutUseCase extends UseCase<bool, void> {
  final AuthRepository authRepository;

  SignOutUseCase({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, bool>> call(void params) async {
    final result = await authRepository.logOut();
    return result;
  }
}
