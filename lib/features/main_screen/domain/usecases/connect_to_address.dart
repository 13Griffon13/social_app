import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/failure.dart';
import '../../../../core/domain/usecase/usecase.dart';
import '../repository/connection_repository.dart';


class ConnectToAddress extends UseCase<bool, String>{

  ConnectionRepository connectionRepository;

  ConnectToAddress({required this.connectionRepository});

  @override
  Future<Either<Failure, bool>> call(String params)  async{
    return connectionRepository.connect(params);
  }

}