import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/network/univalle_network_image.dart';

final _pngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
);

class _RealHttpOverrides extends HttpOverrides {}

// The test binding mocks every HttpClient to answer 400; this hits the
// local server for real.
Future<Object?> resolveError(UnivalleNetworkImage image) =>
    HttpOverrides.runWithHttpOverrides(
      () => resolveWithRealHttp(image),
      _RealHttpOverrides(),
    );

Future<Object?> resolveWithRealHttp(UnivalleNetworkImage image) {
  final completer = Completer<Object?>();
  final stream = image.resolve(ImageConfiguration.empty);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (_, _) {
      completer.complete(null);
      stream.removeListener(listener);
    },
    onError: (error, _) {
      completer.complete(error);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}

void main() {
  late HttpServer server;
  late int statusCode;
  late List<int> body;

  setUp(() async {
    statusCode = HttpStatus.ok;
    body = _pngBytes;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) {
      request.response
        ..statusCode = statusCode
        ..add(body)
        ..close();
    });
  });

  tearDown(() => server.close(force: true));

  String url() => 'http://${server.address.host}:${server.port}/photo.png';

  testWidgets('decodes the downloaded bytes into an image', (tester) async {
    final error = await tester.runAsync(
      () => resolveError(UnivalleNetworkImage(url())),
    );

    expect(error, isNull);
  });

  testWidgets('reports an error on a non-200 response', (tester) async {
    statusCode = HttpStatus.notFound;

    final error = await tester.runAsync(
      () => resolveError(UnivalleNetworkImage(url())),
    );

    expect(error, isA<HttpException>());
  });

  testWidgets('reports an error on an empty body', (tester) async {
    body = const [];

    final error = await tester.runAsync(
      () => resolveError(UnivalleNetworkImage(url())),
    );

    expect(error, isA<HttpException>());
  });

  test('is equal by url', () {
    expect(
      const UnivalleNetworkImage('https://a/b.jpg'),
      const UnivalleNetworkImage('https://a/b.jpg'),
    );
    expect(
      const UnivalleNetworkImage('https://a/b.jpg').hashCode,
      const UnivalleNetworkImage('https://a/b.jpg').hashCode,
    );
    expect(
      const UnivalleNetworkImage('https://a/b.jpg'),
      isNot(const UnivalleNetworkImage('https://a/c.jpg')),
    );
  });
}
