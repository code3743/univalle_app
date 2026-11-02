import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../restaurant_strings.dart';
import '../viewmodels/weekly_menu_view_model.dart';
import '../widgets/weekly_menu/menu_site_link.dart';
import '../widgets/weekly_menu/menu_skeleton.dart';
import '../widgets/weekly_menu/weekly_menu_section.dart';

class RestaurantMenuView extends ConsumerWidget {
  const RestaurantMenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: RestaurantStrings.title,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ShortcutCard(
              iconAsset: AssetPaths.iconUtensils,
              label: RestaurantStrings.buyTicketsLabel,
              accent: AppColors.univalleRed,
              onTap: () => context.push(AppRoutes.restaurantTickets),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncValueWidget(
            value: ref.watch(weeklyMenuViewModelProvider),
            onRetry: () => ref.invalidate(weeklyMenuViewModelProvider),
            skeleton: const MenuSkeleton(),
            data: (menu) => WeeklyMenuSection(menu: menu),
          ),
          const MenuSiteLink(),
        ],
      ),
    );
  }
}
