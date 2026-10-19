import 'package:flutter_riverpod/misc.dart';
import 'package:univalle_app/core/session/current_username_provider.dart';

class _SignedInUsername extends CurrentUsername {
  _SignedInUsername(this._username);

  final String _username;

  @override
  String? build() => _username;
}

/// Overrides [currentUsernameProvider] so view models that require an
/// active session can be built straight from a widget test.
Override signedInAs([String username = 'jdoe']) =>
    currentUsernameProvider.overrideWith(() => _SignedInUsername(username));
