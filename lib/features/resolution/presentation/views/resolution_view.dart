import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../resolution_strings.dart';
import '../viewmodels/resolution_view_model.dart';
import '../widgets/resolution_summary.dart';
import '../widgets/semester_section.dart';

class ResolutionView extends ConsumerWidget {
  const ResolutionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolutionState = ref.watch(resolutionViewModelProvider);

    return AppScaffold(
      title: ResolutionStrings.title,
      body: AsyncValueWidget(
        value: resolutionState,
        onRetry: () => ref.invalidate(resolutionViewModelProvider),
        data: (curriculum) {
          if (curriculum.subjects.isEmpty) {
            return Center(
              child: Text(
                ResolutionStrings.empty,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResolutionSummary(curriculum: curriculum),
              const SizedBox(height: AppSpacing.lg),
              for (final semester in curriculum.semesters) ...[
                SemesterSection(curriculum: curriculum, semester: semester),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          );
        },
      ),
    );
  }
}
