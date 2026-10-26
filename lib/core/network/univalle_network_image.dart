import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'univalle_trusted_http_client.dart';

/// [ImageProvider] that downloads through [createUnivalleTrustedHttpClient],
/// since `Image.network` uses the default client, which can't validate
/// `*.univalle.edu.co` chains missing their intermediate certificate.
@immutable
class UnivalleNetworkImage extends ImageProvider<UnivalleNetworkImage> {
  const UnivalleNetworkImage(this.url);

  final String url;

  static final HttpClient _client = createUnivalleTrustedHttpClient();

  @override
  Future<UnivalleNetworkImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<UnivalleNetworkImage>(this);

  @override
  ImageStreamCompleter loadImage(
    UnivalleNetworkImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _load(key, decode),
      scale: 1.0,
      debugLabel: key.url,
    );
  }

  Future<ui.Codec> _load(
    UnivalleNetworkImage key,
    ImageDecoderCallback decode,
  ) async {
    final request = await _client.getUrl(Uri.parse(key.url));
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      await response.drain<void>();
      throw HttpException('HTTP ${response.statusCode}', uri: request.uri);
    }
    final builder = BytesBuilder(copy: false);
    await for (final chunk in response) {
      builder.add(chunk);
    }
    final Uint8List bytes = builder.takeBytes();
    if (bytes.isEmpty) throw const HttpException('Empty image response');
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) =>
      other is UnivalleNetworkImage && other.url == url;

  @override
  int get hashCode => url.hashCode;
}
