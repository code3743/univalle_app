import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_service.dart';
import 'shared_preferences_service.dart';

part 'local_storage_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with the resolved instance in main.dart',
  );
}

@Riverpod(keepAlive: true)
LocalStorageService localStorageService(Ref ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesService(preferences);
}
