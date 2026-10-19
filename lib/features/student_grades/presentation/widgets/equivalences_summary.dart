import 'package:flutter/material.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/info_card.dart';
import '../../domain/entities/equivalence.dart';
import '../../student_grades_strings.dart';

class EquivalencesSummary extends StatelessWidget {
  const EquivalencesSummary({super.key, required this.equivalences});

  final List<Equivalence> equivalences;

  @override
  Widget build(BuildContext context) {
    final totalCredits = equivalences.fold<int>(
      0,
      (sum, item) => sum + item.credits,
    );

    return Row(
      children: [
        Expanded(
          child: InfoCard(
            iconAsset: AssetPaths.iconNotebook,
            label: StudentGradesStrings.equivalencesSubjectsLabel,
            value: '${equivalences.length}',
            accent: AppColors.accentPurple,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: InfoCard(
            iconAsset: AssetPaths.iconLayers,
            label: StudentGradesStrings.equivalencesCreditsLabel,
            value: '$totalCredits',
            accent: AppColors.accentBlue,
          ),
        ),
      ],
    );
  }
}
