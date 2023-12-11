import 'package:dartz/dartz.dart';

import '../entities/failure.dart';

abstract class UseCase<ResultType, Params>{
  Future<Either<Failure, ResultType>> call(Params params);

}