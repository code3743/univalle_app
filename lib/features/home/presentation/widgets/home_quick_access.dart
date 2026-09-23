import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../../remote_config/domain/entities/app_config.dart';
import '../../home_strings.dart';
import 'modules_state_builder.dart';
import 'quick_access_items.dart';

/// Number of quick-access shortcuts shown on Home; the rest are only
/// reachable from the "Ver todos" screen.
const _homeQuickAccessCount = 6;

class HomeQuickAccess extends StatelessWidget {
  const HomeQuickAccess({
    super.key,
    required this.config,
    required this.onViewAll,
    required this.onRetry,
  });

  final AsyncValue<AppConfig?> config;
  final VoidCallback onViewAll;
  final VoidCallback onRetry;

  static bool _enabled(QuickAccessItem item) => !item.disabled;

  @override
  Widget build(BuildContext context) {
    final appConfig = config.value;
    final hasItems =
        appConfig != null && quickAccessItems(context, appConfig).any(_enabled);

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
            if (hasItems)
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
        ModulesStateBuilder(
          config: config,
          onRetry: onRetry,
          filter: _enabled,
          builder: (context, items) => GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.85,
            children: items
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
        ),
      ],
    );
  }
}
