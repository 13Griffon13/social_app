import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const Failure._();

  const factory Failure({
    required String name,
    @Default('') String description,
  }) = _Failure;

  factory Failure.fromException(Object e) =>
      Failure(name: e.runtimeType.toString(), description: e.toString());
}
