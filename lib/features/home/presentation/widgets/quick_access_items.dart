import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../home_strings.dart';

class QuickAccessItem {
  const QuickAccessItem({
    required this.iconAsset,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final Color accent;
  final VoidCallback onTap;
}

List<QuickAccessItem> quickAccessItems(BuildContext context) {
  return [
    QuickAccessItem(
      iconAsset: AssetPaths.iconNotebook,
      label: HomeStrings.gradesShortcut,
      accent: AppColors.univalleRed,
      onTap: () => context.push(AppRoutes.grades),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconIdCard,
      label: HomeStrings.studentCardShortcut,
      accent: AppColors.accentPurple,
      onTap: () => context.push(AppRoutes.digitalCard),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconLayers,
      label: HomeStrings.tabuladoShortcut,
      accent: AppColors.accentGreen,
      onTap: () => context.push(AppRoutes.tabulate),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconRoute,
      label: HomeStrings.resolutionShortcut,
      accent: AppColors.accentAmber,
      onTap: () => context.push(AppRoutes.resolution),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconStar,
      label: HomeStrings.teacherRatingShortcut,
      accent: AppColors.accentBlue,
      onTap: () => context.push(AppRoutes.teacherRating),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconCalendar,
      label: HomeStrings.scheduleShortcut,
      accent: AppColors.accentPurple,
      onTap: () => context.push(AppRoutes.schedule),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconLibrary,
      label: HomeStrings.libraryShortcut,
      accent: AppColors.accentPink,
      onTap: () => context.push(AppRoutes.library),
    ),
    QuickAccessItem(
      iconAsset: AssetPaths.iconUtensils,
      label: HomeStrings.restaurantShortcut,
      accent: AppColors.univalleRed,
      onTap: () => context.push(AppRoutes.restaurant),
    ),
  ];
}
