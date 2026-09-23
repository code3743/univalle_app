import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';

class GradesSkeleton extends StatelessWidget {
  const GradesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 76, radius: 20)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: ShimmerBox(height: 76, radius: 20)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _PeriodSectionSkeleton(),
        const SizedBox(height: AppSpacing.lg),
        const _PeriodSectionSkeleton(),
      ],
    );
  }
}

class _PeriodSectionSkeleton extends StatelessWidget {
  const _PeriodSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 96, radius: 0),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 4; i++) ...[
                  const ShimmerBox(height: 20, width: double.infinity),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
