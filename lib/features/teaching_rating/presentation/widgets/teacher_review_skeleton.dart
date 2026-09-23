import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';

class TeacherReviewSkeleton extends StatelessWidget {
  const TeacherReviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 180, height: 22),
        const SizedBox(height: AppSpacing.sm),
        const ShimmerBox(width: 140, height: 16),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(width: 120, height: 20),
        const SizedBox(height: AppSpacing.sm),
        const ShimmerBox(height: 8, width: double.infinity, radius: 20),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: double.infinity, height: 20),
              const SizedBox(height: AppSpacing.lg),
              for (var i = 0; i < 5; i++) ...[
                const ShimmerBox(
                  height: 48,
                  width: double.infinity,
                  radius: 16,
                ),
                if (i != 4) const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
