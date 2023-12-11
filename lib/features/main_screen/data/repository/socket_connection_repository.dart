import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/domain/entities/failure.dart';
import '../../domain/repository/connection_repository.dart';
import '../services/socket_service.dart';


class SocketConnectionRepository extends ConnectionRepository {

  final int connectionPort = 4567;
  SocketService socketService;
  BehaviorSubject<bool> connectionSubject;

  SocketConnectionRepository({required this.socketService})
      : connectionSubject = BehaviorSubject() {
    socketService.connectionStream.listen((event) {
      connectionSubject.add(event);
    });
  }

  @override
  Future<Either<Failure, bool>> connect(String address) async {
     return socketService.connect(address, connectionPort);
  }

  @override
  Stream<bool> get connectionStream => connectionSubject.stream;
}
