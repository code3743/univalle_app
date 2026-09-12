import 'package:flutter/material.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/info_card.dart';
import '../../domain/entities/curriculum.dart';
import '../../resolution_strings.dart';

class ResolutionSummary extends StatelessWidget {
  const ResolutionSummary({super.key, required this.curriculum});

  final Curriculum curriculum;

  @override
  Widget build(BuildContext context) {
    final totalCredits = curriculum.subjects.fold<int>(
      0,
      (sum, subject) => sum + subject.credits,
    );

    return Row(
      children: [
        Expanded(
          child: InfoCard(
            iconAsset: AssetPaths.iconLibrary,
            label: ResolutionStrings.subjectsCountLabel,
            value: '${curriculum.subjects.length}',
            accent: AppColors.accentBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: InfoCard(
            iconAsset: AssetPaths.iconLayers,
            label: ResolutionStrings.totalCreditsLabel,
            value: '$totalCredits',
            accent: AppColors.accentGreen,
          ),
        ),
      ],
    );
  }
}
