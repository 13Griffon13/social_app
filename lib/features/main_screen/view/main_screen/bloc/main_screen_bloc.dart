
import 'package:flutter_bloc/flutter_bloc.dart';


import 'main_screen_event.dart';
import 'main_screen_state.dart';


class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {

  MainScreenBloc() : super(const MainScreenState()) {
    on<MainScreenEvent>((event, emit) async{
     await event.map(
        connectionAttempt: (connectionAttempt) async {

        },
        connectionStateChanged: (connectionStateChanged) {
        },
        addressChanged: (addressChanged) {

        },
      );
    });

  }

}
