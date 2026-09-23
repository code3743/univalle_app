import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../../remote_config/presentation/viewmodels/remote_config_view_model.dart';
import '../../home_strings.dart';
import '../widgets/modules_state_builder.dart';

class AllShortcutsView extends ConsumerWidget {
  const AllShortcutsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigViewModelProvider);

    return AppScaffold(
      title: HomeStrings.allFunctionalitiesTitle,
      scrollable: false,
      body: ModulesStateBuilder(
        config: config,
        onRetry: () => ref.invalidate(remoteConfigViewModelProvider),
        builder: (context, items) => GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.85,
          children: items
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
      ),
    );
  }
}
