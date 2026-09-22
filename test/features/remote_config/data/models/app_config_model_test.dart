import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/remote_config/data/models/app_config_model.dart';

void main() {
  late Map<String, dynamic> fullJson;
  late Map<String, dynamic> emptyJson;
  late Map<String, dynamic> configStatusJson;
  late Map<String, dynamic> modulesJson;
  late Map<String, dynamic> welcomeJson;

  setUpAll(() {
    fullJson = jsonDecode(
      File('test/fixtures/remote_config/app_config.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    emptyJson = jsonDecode(
      File('test/fixtures/remote_config/app_config_empty.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    configStatusJson = jsonDecode(
      File('test/fixtures/remote_config/app_config_status.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    modulesJson = jsonDecode(
      File('test/fixtures/remote_config/app_modules.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    welcomeJson = jsonDecode(
      File('test/fixtures/remote_config/app_welcome.json').readAsStringSync(),
    ) as Map<String, dynamic>;
  });

  test('fromJson parses a fully populated config', () {
    final model = AppConfigModel.fromJson(fullJson);

    expect(model.platformEnabled, isTrue);
    expect(model.maintenance.enabled, isFalse);
    expect(model.update.latestVersion, '1.0.0');
    expect(model.modules, hasLength(2));
    expect(model.modules.first.key, 'grades');
    expect(model.modules.first.color, '#FF0000');
    expect(model.quickAccess, ['grades', 'digital_card']);
    expect(model.welcome.enabled, isTrue);
    expect(model.welcome.imageUrl, 'https://example.com/banner.png');
  });

  test('fromJson parses nullable welcome fields and empty lists', () {
    final model = AppConfigModel.fromJson(emptyJson);

    expect(model.platformEnabled, isFalse);
    expect(model.maintenance.enabled, isTrue);
    expect(model.modules, isEmpty);
    expect(model.quickAccess, isEmpty);
    expect(model.welcome.imageUrl, isNull);
    expect(model.welcome.linkUrl, isNull);
  });

  test('toJson then fromJson round-trips to an equivalent model', () {
    final original = AppConfigModel.fromJson(fullJson);

    final roundTripped = AppConfigModel.fromJson(original.toJson());

    expect(roundTripped.toJson(), original.toJson());
  });

  test('toEntity maps every field, including nested nullables', () {
    final entity = AppConfigModel.fromJson(fullJson).toEntity();

    expect(entity.platformEnabled, isTrue);
    expect(entity.modules.first.route, '/grades');
    expect(entity.welcome.linkUrl, 'https://example.com/evento');
  });

  test('fromParts merges the backend\'s split endpoint responses', () {
    final model = AppConfigModel.fromParts(
      config: configStatusJson,
      modules: modulesJson,
      welcome: welcomeJson,
    );

    expect(model.platformEnabled, isTrue);
    expect(model.update.latestVersion, '1.0.0');
    expect(model.modules, hasLength(2));
    expect(model.quickAccess, ['grades', 'digital_card']);
    expect(model.welcome.title, 'Semana de la ciencia');
  });
}
