import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_events.dart';
import 'chat_state.dart';


class ChatBloc extends Bloc<ChatEvent,ChatState>{
  ChatBloc():super(const ChatState()){
    on<ChatEvent>((event,emit){

    });
  }

}