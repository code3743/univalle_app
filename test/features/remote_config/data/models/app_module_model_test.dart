import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/remote_config/data/models/app_module_model.dart';

void main() {
  test('fromJson parses a disabled module with its message', () {
    final model = AppModuleModel.fromJson({
      'key': 'biblioteca',
      'label': 'Biblioteca',
      'icon': 'book',
      'route': '/biblioteca',
      'color': '#2196F3',
      'disabled': true,
      'disabledMessage': 'En mantenimiento hasta el 30/09',
    });

    expect(model.disabled, isTrue);
    expect(model.disabledMessage, 'En mantenimiento hasta el 30/09');
  });

  test('fromJson defaults disabled to false when the fields are absent', () {
    final model = AppModuleModel.fromJson({
      'key': 'grades',
      'label': 'Historial de notas',
      'icon': 'notebook-text',
      'route': '/grades',
      'color': '#FF0000',
    });

    expect(model.disabled, isFalse);
    expect(model.disabledMessage, isNull);
  });

  test('toJson then fromJson round-trips a disabled module', () {
    const original = AppModuleModel(
      key: 'biblioteca',
      label: 'Biblioteca',
      icon: 'book',
      route: '/biblioteca',
      color: '#2196F3',
      disabled: true,
      disabledMessage: 'En mantenimiento hasta el 30/09',
    );

    final roundTripped = AppModuleModel.fromJson(original.toJson());

    expect(roundTripped.toJson(), original.toJson());
  });

  test('toEntity maps disabled and disabledMessage', () {
    const model = AppModuleModel(
      key: 'biblioteca',
      label: 'Biblioteca',
      icon: 'book',
      route: '/biblioteca',
      color: '#2196F3',
      disabled: true,
      disabledMessage: 'En mantenimiento hasta el 30/09',
    );

    final entity = model.toEntity();

    expect(entity.disabled, isTrue);
    expect(entity.disabledMessage, 'En mantenimiento hasta el 30/09');
  });
}
