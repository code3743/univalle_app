import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../../remote_config/presentation/viewmodels/remote_config_view_model.dart';
import '../../home_strings.dart';
import '../widgets/quick_access_items.dart';

class AllShortcutsView extends ConsumerWidget {
  const AllShortcutsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigViewModelProvider).value;

    return AppScaffold(
      title: HomeStrings.allFunctionalitiesTitle,
      scrollable: false,
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
        children: quickAccessItems(context, config)
            .map(
              (item) => ShortcutCard(
                iconAsset: item.iconAsset,
                label: item.label,
                accent: item.accent,
                onTap: item.onTap,
                disabled: item.disabled,
              ),
            )
            .toList(),
      ),
    );
  }
}
