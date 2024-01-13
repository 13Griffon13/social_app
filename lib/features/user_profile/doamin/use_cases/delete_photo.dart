import 'package:dartz/dartz.dart';
import 'package:social_app/core/domain/entities/failure.dart';
import 'package:social_app/core/domain/usecase/usecase.dart';
import 'package:social_app/features/user_profile/doamin/repo/user_repository.dart';

class DeletePhotoUseCase extends UseCase<bool, void>{
  final UserRepository userRepository;

  DeletePhotoUseCase({required this.userRepository});


  @override
  Future<Either<Failure, bool>> call([void params]) {
    return userRepository.deletePhoto();
  }

}