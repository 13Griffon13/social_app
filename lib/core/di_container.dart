import 'package:get_it/get_it.dart';

import '../features/main_screen/data/repository/socket_connection_repository.dart';
import '../features/main_screen/data/services/socket_service.dart';
import '../features/main_screen/domain/usecases/connect_to_address.dart';


final getIt = GetIt.instance;

void diInit() {
  ///Services
  getIt.registerLazySingleton<SocketService>(() => SocketService());

  ///Repos
  getIt.registerLazySingleton<SocketConnectionRepository>(
      () => SocketConnectionRepository(
            socketService: getIt.get<SocketService>(),
          ));

  ///UseCases
  getIt.registerLazySingleton<ConnectToAddress>(() => ConnectToAddress(
      connectionRepository: getIt.get<SocketConnectionRepository>()));
}
