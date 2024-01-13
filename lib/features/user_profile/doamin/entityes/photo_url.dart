import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_url.freezed.dart';

enum PhotoSource {
  network,
  file,
  none,
  deleted;
}

@freezed
class PhotoUrl with _$PhotoUrl {
  const PhotoUrl._();

  const factory PhotoUrl({
    required PhotoSource source,
    String? link,
  }) = _PhotoUrl;

  factory PhotoUrl.none() => PhotoUrl(source: PhotoSource.none);

  factory PhotoUrl.network(String link) =>
      PhotoUrl(source: PhotoSource.network, link: link);

  factory PhotoUrl.file(String link) =>
      PhotoUrl(source: PhotoSource.file, link: link);
}
