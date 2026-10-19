import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../student_grades_strings.dart';
import '../viewmodels/grades_view_model.dart';
import '../widgets/equivalence_tile.dart';
import '../widgets/equivalences_skeleton.dart';
import '../widgets/equivalences_summary.dart';

class EquivalencesView extends ConsumerWidget {
  const EquivalencesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gradesViewModelProvider);

    return AppScaffold(
      title: StudentGradesStrings.equivalencesTitle,
      body: AsyncValueWidget(
        value: state,
        onRetry: () => ref.invalidate(gradesViewModelProvider),
        skeleton: const EquivalencesSkeleton(),
        data: (history) {
          final equivalences = history.equivalences;
          if (equivalences.isEmpty) {
            return const AppEmptyView(
              icon: Icons.swap_horiz,
              title: StudentGradesStrings.equivalencesEmpty,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EquivalencesSummary(equivalences: equivalences),
              const SizedBox(height: AppSpacing.lg),
              Material(
                elevation: 1,
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (final item in equivalences)
                      EquivalenceTile(equivalence: item),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
