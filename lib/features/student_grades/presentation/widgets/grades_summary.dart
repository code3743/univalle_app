import 'package:flutter/material.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/sira_period_formatter.dart';
import '../../../../core/widgets/info_card.dart';
import '../../domain/entities/grades.dart';
import '../../student_grades_strings.dart';

/// Client-computed overview across all fetched periods — a simple average
/// per period, not the official SIRA cumulative average shown on Home.
class GradesSummary extends StatelessWidget {
  const GradesSummary({super.key, required this.periods});

  /// Must be non-empty.
  final List<Grades> periods;

  @override
  Widget build(BuildContext context) {
    final bestPeriod = periods.reduce(
      (best, period) => period.average > best.average ? period : best,
    );

    return Row(
      children: [
        Expanded(
          child: InfoCard(
            iconAsset: AssetPaths.iconCalendar,
            label: StudentGradesStrings.periodsCountLabel,
            value: '${periods.length}',
            accent: AppColors.accentBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: InfoCard(
            iconAsset: AssetPaths.iconStar,
            label: StudentGradesStrings.bestPeriodLabel,
            value:
                '${SiraPeriodFormatter.shortCode(bestPeriod.period)} · '
                '${bestPeriod.average.toStringAsFixed(1)}',
            accent: AppColors.accentAmber,
          ),
        ),
      ],
    );
  }
}
