import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_screen_event.freezed.dart';

@freezed
class MainScreenEvent with _$MainScreenEvent {
  const MainScreenEvent._();

  const factory MainScreenEvent.addressChanged({required String newAddress}) =
      _AddressChanged;

  const factory MainScreenEvent.connectionAttempt() = _ConnectionAttempt;

  const factory MainScreenEvent.connectionStateChanged(bool newState) =
      _ConnectionStateChanged;
}
