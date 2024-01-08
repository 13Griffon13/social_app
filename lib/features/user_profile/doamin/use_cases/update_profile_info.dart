import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';
import 'package:social_app/features/user_profile/doamin/entityes/user_entity.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';

class UpdateProfileInfoUseCase extends UseCase<bool, Params> {
  final UserRepository userRepository;

  UpdateProfileInfoUseCase({required this.userRepository});

  @override
  Future<Either<Failure, bool>> call(Params params) {
    return userRepository.updateUserData(
      params.newAvatarPath,
      params.newStatus,
      params.newBio,
    );
  }
}

class Params {
  final String? newAvatarPath;
  final String? newStatus;
  final String? newBio;

  Params({this.newAvatarPath, this.newStatus, this.newBio});
}
