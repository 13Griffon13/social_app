import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/failure.dart';

abstract class ConnectionRepository{
  Stream<bool> get connectionStream;

  Future<Either<Failure, bool>> connect(String address);
}