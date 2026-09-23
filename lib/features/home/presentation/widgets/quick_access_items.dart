import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../remote_config/domain/entities/app_config.dart';
import '../../../remote_config/domain/entities/app_module.dart';
import '../../../remote_config/presentation/utils/module_style.dart';
import '../../home_strings.dart';

class QuickAccessItem {
  const QuickAccessItem({
    required this.key,
    required this.iconAsset,
    required this.label,
    required this.accent,
    required this.onTap,
    this.disabled = false,
  });

  final String key;
  final String iconAsset;
  final String label;
  final Color accent;
  final VoidCallback onTap;
  final bool disabled;
}

/// Routes the app actually has screens for; a server-sent module pointing
/// anywhere else falls back to `showComingSoon` instead of a dead navigation.
const _knownRoutes = {
  AppRoutes.grades,
  AppRoutes.digitalCard,
  AppRoutes.tabulate,
  AppRoutes.resolution,
  AppRoutes.teacherRating,
  AppRoutes.schedule,
  AppRoutes.library,
  AppRoutes.restaurant,
  AppRoutes.news,
};

/// The server (`config.modules` filtered/ordered by `config.quickAccess`) is
/// the only source of truth for shortcuts — unknown local shortcuts never
/// existed here, and known ones pick up the label/icon/color the backend
/// sends. Callers are responsible for handling the case where the config
/// itself isn't available yet (see `ModulesStateBuilder`).
List<QuickAccessItem> quickAccessItems(BuildContext context, AppConfig config) {
  final byKey = {for (final module in config.modules) module.key: module};
  final quickKeys = config.quickAccess.toSet();
  final orderedModules = [
    for (final key in config.quickAccess) ?byKey[key],
    for (final module in config.modules)
      if (!quickKeys.contains(module.key)) module,
  ];

  return orderedModules
      .map(
        (module) => QuickAccessItem(
          key: module.key,
          iconAsset: moduleIconAsset(module.icon),
          label: module.label,
          accent: moduleColor(module.color),
          disabled: module.disabled,
          onTap: () => _goTo(context, module),
        ),
      )
      .toList();
}

void _goTo(BuildContext context, AppModule module) {
  if (module.disabled) {
    context.showSnack(module.disabledMessage ?? HomeStrings.comingSoon);
  } else if (_knownRoutes.contains(module.route)) {
    context.push(module.route);
  } else {
    context.showSnack(HomeStrings.comingSoon);
  }
}
