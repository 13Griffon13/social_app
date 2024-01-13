import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';

class UpdateProfileInfoUseCase extends UseCase<bool, UpdateProfileParams> {
  final UserRepository userRepository;

  UpdateProfileInfoUseCase({required this.userRepository});

  @override
  Future<Either<Failure, bool>> call(UpdateProfileParams params) {
    return userRepository.updateUserData(
      params.newStatus,
      params.newBio,
    );
  }
}

class UpdateProfileParams {
  final String? newStatus;
  final String? newBio;

  UpdateProfileParams({this.newStatus, this.newBio});
}
