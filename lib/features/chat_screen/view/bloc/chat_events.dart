import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../repository/entity/message.dart';

part 'chat_events.freezed.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const ChatEvent._();

  const factory ChatEvent.messageSent({
    required String text,
  }) = _MessageSent;

  const factory ChatEvent.messageReceived({required Message message}) =
      _MessageReceived;
}
