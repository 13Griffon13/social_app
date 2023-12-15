import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/domain/entities/failure.dart';


part 'main_screen_state.freezed.dart';

@freezed
class MainScreenState with _$MainScreenState {

  const MainScreenState._();

  const factory MainScreenState({
    @Default(false) bool connected,
    @Default('') String address,
    Failure? error
  }) = _MainScreenState;

  bool get haveError => error!=null;
}