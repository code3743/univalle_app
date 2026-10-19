import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shortcut_card.dart';
import '../../student_grades_strings.dart';
import '../viewmodels/grades_view_model.dart';

/// Hidden while loading, on error, or when the student has no equivalences:
/// it's a secondary entry point, so it never blocks or alarms the grades screen.
class EquivalencesShortcut extends ConsumerWidget {
  const EquivalencesShortcut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equivalences = ref.watch(gradesViewModelProvider).value?.equivalences;
    if (equivalences == null || equivalences.isEmpty) {
      return const SizedBox.shrink();
    }

    final credits = equivalences.fold<int>(0, (sum, e) => sum + e.credits);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        child: ShortcutCard(
          iconAsset: AssetPaths.iconNotebook,
          label: StudentGradesStrings.equivalencesShortcutLabel(
            equivalences.length,
            credits,
          ),
          accent: AppColors.accentPurple,
          onTap: () => context.push(AppRoutes.equivalences),
        ),
      ),
    );
  }
}
