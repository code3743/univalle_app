import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../teaching_rating_strings.dart';

class TeacherRatingBanner extends StatelessWidget {
  const TeacherRatingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign_rounded, color: AppColors.accentBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              TeachingRatingStrings.banner,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
