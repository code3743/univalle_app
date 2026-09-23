import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../remote_config/domain/entities/app_config.dart';
import '../../home_strings.dart';
import 'quick_access_items.dart';

/// Renders modules from `AsyncValue<AppConfig?>`, distinguishing the states
/// a `.value`-only read can't tell apart: still loading, unavailable (fetch
/// failed and there's no cached config either — `AppConfig?` resolved to
/// null), config loaded but with no modules to show (either the server sent
/// none, or [filter] removed all of them), and ready.
///
/// By the time Home mounts, `SplashView` has already waited for the config
/// to settle, so the loading state normally only shows up again after
/// [onRetry] — hence checking `config.value == null` instead of
/// `!config.hasValue`: an `AsyncData(null)` retried via `ref.invalidate`
/// still reports `hasValue: true` (riverpod keeps the previous value around
/// while it reloads), which would otherwise hide the spinner entirely.
class ModulesStateBuilder extends StatelessWidget {
  const ModulesStateBuilder({
    super.key,
    required this.config,
    required this.onRetry,
    required this.builder,
    this.filter,
  });

  final AsyncValue<AppConfig?> config;
  final VoidCallback onRetry;
  final bool Function(QuickAccessItem item)? filter;
  final Widget Function(BuildContext context, List<QuickAccessItem> items)
  builder;

  @override
  Widget build(BuildContext context) {
    if (config.isLoading && config.value == null) {
      return const AppLoadingIndicator();
    }

    final appConfig = config.value;
    if (appConfig == null) {
      return AppEmptyView(
        icon: Icons.cloud_off_outlined,
        title: HomeStrings.modulesUnavailableTitle,
        message: HomeStrings.modulesUnavailableMessage,
        onRetry: onRetry,
      );
    }

    final items = quickAccessItems(context, appConfig);
    final filtered = filter == null ? items : items.where(filter!).toList();

    if (filtered.isEmpty) {
      return AppEmptyView(
        icon: Icons.apps_outlined,
        title: HomeStrings.modulesEmptyTitle,
        message: HomeStrings.modulesEmptyMessage,
      );
    }

    return builder(context, filtered);
  }
}
