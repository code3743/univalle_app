import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/main.dart' as app;

void main() {
  test('coverage helper — pulls the whole app import graph into coverage', () {
    expect(app.MainApp, isNotNull);
  });
}
