import '../../auth_strings.dart';

final _usernamePattern = RegExp(r'^\d{4,}-\d{2,}$');

String? validateUsername(String? value) {
  final username = value?.trim() ?? '';
  if (username.isEmpty) return AuthStrings.usernameRequired;
  if (!_usernamePattern.hasMatch(username)) return AuthStrings.usernameInvalid;
  return null;
}
