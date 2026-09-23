import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';

class ResolutionSkeleton extends StatelessWidget {
  const ResolutionSkeleton({super.key});

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
        const _SemesterSectionSkeleton(),
        const SizedBox(height: AppSpacing.lg),
        const _SemesterSectionSkeleton(),
      ],
    );
  }
}

class _SemesterSectionSkeleton extends StatelessWidget {
  const _SemesterSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 140, height: 18),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < 3; i++) ...[
          const ShimmerBox(height: 64, width: double.infinity, radius: 16),
          if (i != 2) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
