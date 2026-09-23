import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../../remote_config/domain/entities/app_config.dart';
import '../../home_strings.dart';
import 'quick_access_items.dart';

/// Number of quick-access shortcuts shown on Home; the rest are only
/// reachable from the "Ver todos" screen.
const _homeQuickAccessCount = 6;

class HomeQuickAccess extends StatelessWidget {
  const HomeQuickAccess({
    super.key,
    required this.config,
    required this.onViewAll,
  });

  final AppConfig? config;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              HomeStrings.quickAccess,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: onViewAll,
              child: Row(
                children: [
                  Text(HomeStrings.viewAll),
                  const Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.85,
          children: quickAccessItems(context, config)
              .where((item) => !item.disabled)
              .take(_homeQuickAccessCount)
              .map(
                (item) => ShortcutCard(
                  iconAsset: item.iconAsset,
                  label: item.label,
                  accent: item.accent,
                  onTap: item.onTap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
