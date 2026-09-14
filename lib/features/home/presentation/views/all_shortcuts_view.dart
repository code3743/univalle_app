import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../home_strings.dart';
import '../widgets/quick_access_items.dart';

class AllShortcutsView extends StatelessWidget {
  const AllShortcutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: HomeStrings.allFunctionalitiesTitle,
      scrollable: false,
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
        children: quickAccessItems(context)
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
    );
  }
}
