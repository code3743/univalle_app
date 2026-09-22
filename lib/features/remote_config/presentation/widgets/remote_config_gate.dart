import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_config.dart';
import '../viewmodels/remote_config_view_model.dart';
import '../views/maintenance_view.dart';
import '../views/update_required_view.dart';

/// Wraps the whole app (from `MaterialApp.router`'s `builder:` slot). While
/// the config is loading, or if fetching it failed, the app underneath
/// renders normally — see the fail-open comment on [RemoteConfigViewModel].
/// Only an explicit maintenance flag or a required update blocks the app;
/// everything else in [AppConfig] (modules, banner, announcements) is
/// consumed further down, inside Home.
class RemoteConfigGate extends ConsumerWidget {
  const RemoteConfigGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigViewModelProvider).value;
    if (config == null) return child;

    if (config.maintenance.enabled) {
      return MaintenanceView(maintenance: config.maintenance);
    }
    if (!config.platformEnabled) {
      return const MaintenanceView(
        maintenance: MaintenanceStatus(enabled: true, title: '', message: ''),
      );
    }
    if (config.update.updateRequired) {
      return UpdateRequiredView(update: config.update);
    }

    return child;
  }
}
