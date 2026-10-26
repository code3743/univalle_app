import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/univalle_network_image.dart';

part 'current_photo_url_provider.g.dart';

/// Authenticated student's cached SIRA photo URL, shared across features.
/// Always null-safe to consume: the photo is best-effort and optional.
@Riverpod(keepAlive: true)
class CurrentPhotoUrl extends _$CurrentPhotoUrl {
  @override
  String? build() => null;

  void set(String? photoUrl) {
    if (photoUrl != null) UnivalleNetworkImage(photoUrl).evict();
    state = photoUrl;
  }

  void clear() => state = null;
}
