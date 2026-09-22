import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../remote_config/domain/entities/app_config.dart';
import '../../../remote_config/presentation/utils/module_style.dart';
import '../../home_strings.dart';

class QuickAccessItem {
  const QuickAccessItem({
    required this.key,
    required this.iconAsset,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final String key;
  final String iconAsset;
  final String label;
  final Color accent;
  final VoidCallback onTap;
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
/// the source of truth whenever it's available — unknown local shortcuts
/// disappear if the backend doesn't mention them, and known ones pick up
/// the label/icon/color the backend sends. Falls back to the local catalog
/// only when [config] is null (still loading, or the backend is down and
/// there's no cached config either).
List<QuickAccessItem> quickAccessItems(
  BuildContext context,
  AppConfig? config,
) {
  if (config == null) return _localQuickAccessItems(context);

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
          onTap: () => _goTo(context, module.route),
        ),
      )
      .toList();
}

void _goTo(BuildContext context, String route) {
  if (_knownRoutes.contains(route)) {
    context.push(route);
  } else {
    context.showSnack(HomeStrings.comingSoon);
  }
}

List<QuickAccessItem> _localQuickAccessItems(BuildContext context) {
  return [
    QuickAccessItem(
      key: 'grades',
      iconAsset: AssetPaths.iconNotebook,
      label: HomeStrings.gradesShortcut,
      accent: AppColors.univalleRed,
      onTap: () => context.push(AppRoutes.grades),
    ),
    QuickAccessItem(
      key: 'digital_card',
      iconAsset: AssetPaths.iconIdCard,
      label: HomeStrings.studentCardShortcut,
      accent: AppColors.accentPurple,
      onTap: () => context.push(AppRoutes.digitalCard),
    ),
    QuickAccessItem(
      key: 'tabulate',
      iconAsset: AssetPaths.iconLayers,
      label: HomeStrings.tabuladoShortcut,
      accent: AppColors.accentGreen,
      onTap: () => context.push(AppRoutes.tabulate),
    ),
    QuickAccessItem(
      key: 'resolution',
      iconAsset: AssetPaths.iconRoute,
      label: HomeStrings.resolutionShortcut,
      accent: AppColors.accentAmber,
      onTap: () => context.push(AppRoutes.resolution),
    ),
    QuickAccessItem(
      key: 'teacher_rating',
      iconAsset: AssetPaths.iconStar,
      label: HomeStrings.teacherRatingShortcut,
      accent: AppColors.accentBlue,
      onTap: () => context.push(AppRoutes.teacherRating),
    ),
    QuickAccessItem(
      key: 'schedule',
      iconAsset: AssetPaths.iconCalendar,
      label: HomeStrings.scheduleShortcut,
      accent: AppColors.accentPurple,
      onTap: () => context.push(AppRoutes.schedule),
    ),
    QuickAccessItem(
      key: 'library',
      iconAsset: AssetPaths.iconLibrary,
      label: HomeStrings.libraryShortcut,
      accent: AppColors.accentPink,
      onTap: () => context.push(AppRoutes.library),
    ),
    QuickAccessItem(
      key: 'restaurant',
      iconAsset: AssetPaths.iconUtensils,
      label: HomeStrings.restaurantShortcut,
      accent: AppColors.univalleRed,
      onTap: () => context.push(AppRoutes.restaurant),
    ),
    QuickAccessItem(
      key: 'news',
      iconAsset: AssetPaths.iconNewspaper,
      label: HomeStrings.newsShortcut,
      accent: AppColors.accentBlue,
      onTap: () => context.push(AppRoutes.news),
    ),
  ];
}
