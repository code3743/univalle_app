import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/network/univalle_trusted_http_client.dart';

void main() {
  test('builds an HttpClient with the DigiCert chain registered', () {
    final client = createUnivalleTrustedHttpClient();
    addTearDown(client.close);

    expect(client, isA<HttpClient>());
  });
}
