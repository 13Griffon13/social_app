import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/connection_repository.dart';
import '../../domain/usecases/connect_to_address.dart';
import 'main_screen_event.dart';
import 'main_screen_state.dart';


class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  ConnectionRepository connectionRepository;
  ConnectToAddress connectToAddressUseCase;
  late StreamSubscription<bool> _connectionSubscription;

  MainScreenBloc({
    required this.connectionRepository,
    required this.connectToAddressUseCase,
  }) : super(const MainScreenState()) {
    on<MainScreenEvent>((event, emit) async{
     await event.map(
        connectionAttempt: (connectionAttempt) async {
          print('bloc connection event');
          var result = await connectToAddressUseCase(state.address);
          print(result.toString());
          if (result.isLeft()) {
            result.fold(
              (l) {
                emit(state.copyWith(error: l));
                emit(state.copyWith(error: null));
              },
              (r) {},
            );
          }
        },
        connectionStateChanged: (connectionStateChanged) {
          emit(state.copyWith(connected: connectionStateChanged.newState));
        },
        addressChanged: (addressChanged) {
          emit(
            state.copyWith(address: addressChanged.newAddress),
          );
        },
      );
    });
    _connectionSubscription = connectionRepository.connectionStream.listen(
      (event) {
        add(MainScreenEvent.connectionStateChanged(event));
      },
    );
  }

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}
