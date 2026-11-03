import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/sira_period_formatter.dart';
import '../../../domain/entities/grades.dart';
import '../../../student_grades_strings.dart';
import '../subject_tile.dart';
import 'period_header_divider.dart';
import 'period_header_stat.dart';

class PeriodGradesSection extends StatelessWidget {
  const PeriodGradesSection({
    super.key,
    required this.grades,
    required this.accent,
  });

  final Grades grades;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 1,
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: accent.withValues(alpha: 0.12),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          SiraPeriodFormatter.shortCode(grades.period),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (grades.hasAcademicMerit) ...[
                          const SizedBox(width: 6),
                          const Tooltip(
                            message: StudentGradesStrings.academicMeritTooltip,
                            triggerMode: TooltipTriggerMode.tap,
                            child: Icon(
                              Icons.workspace_premium,
                              size: 18,
                              color: AppColors.accentAmber,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Spacer(),
                    Text(
                      SiraPeriodFormatter.format(grades.period),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PeriodHeaderStat(
                      value: grades.average.toStringAsFixed(1),
                      label: StudentGradesStrings.averageLabel,
                    ),
                    const PeriodHeaderDivider(),
                    PeriodHeaderStat(
                      value: '${grades.credits}',
                      label: StudentGradesStrings.creditsLabel,
                    ),
                    const PeriodHeaderDivider(),
                    PeriodHeaderStat(
                      value: grades.approvedPercentage,
                      label: StudentGradesStrings.approvedLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: Text(
              StudentGradesStrings.subjectsSectionLabel,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemCount: grades.subjects.length,
            itemBuilder: (context, index) =>
                SubjectTile(subject: grades.subjects[index]),
          ),
        ],
      ),
    );
  }
}
