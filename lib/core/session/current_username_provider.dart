import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_username_provider.g.dart';

/// Authenticated student's SIRA username, shared across features.
@Riverpod(keepAlive: true)
class CurrentUsername extends _$CurrentUsername {
  @override
  String? build() => null;

  void set(String username) => state = username;
  void clear() => state = null;
}
