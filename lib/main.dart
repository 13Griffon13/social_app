import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di_container.dart';
import 'features/main_screen/data/repository/socket_connection_repository.dart';
import 'features/main_screen/domain/usecases/connect_to_address.dart';
import 'features/main_screen/view/bloc/main_screen_bloc.dart';
import 'navigation/app_router.dart';


void main() {
  diInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainScreenBloc>(
          create: (context) => MainScreenBloc(
            connectionRepository: getIt.get<SocketConnectionRepository>(),
            connectToAddressUseCase: getIt.get<ConnectToAddress>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'socket_practice',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.green.shade300,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
