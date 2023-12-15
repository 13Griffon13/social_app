import 'dart:io';
import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/failure.dart';

class SocketService {
  final StreamController<bool> _connectionStreamController = StreamController();

  Stream<bool> get connectionStream => _connectionStreamController.stream;

  final StreamController<String> _dataStreamController = StreamController();

  Stream<String> get dataStream => _dataStreamController.stream;

  Socket? _socket;
  late ServerSocket _server;

  Future<void> openServer(int port) async {
    _server = await ServerSocket.bind('localhost', port);
    _server.listen((Socket socket) {
      _socket = socket;
      _initSocket();
      _connectionStreamController.sink.add(true);
    });
  }

  Future<Either<Failure, bool>> connect(String address, int port) async {
    try {
      _socket = await Socket.connect(address, port);
      _initSocket();
      _connectionStreamController.sink.add(true);
      return right(true);
    } catch (e) {
      return Left(
          Failure(name: e.runtimeType.toString(), description: e.toString()));
    }
  }

  Future<Either<Failure, bool>> sendMassage(String massage) async {
    try {
      _socket?.add(massage.codeUnits);
      await _socket?.flush();
      return right(true);
    } catch (e) {
      return Left(
          Failure(name: e.runtimeType.toString(), description: e.toString()));
    }
  }

  void _initSocket() {
    _socket?.listen((event) {
      _dataStreamController.sink.add(String.fromCharCodes(event));
    });
  }

  void close() {
    _server.close();
    _socket?.close();
    _connectionStreamController.sink.add(false);
    _connectionStreamController.close();
    _dataStreamController.close();
  }
}
