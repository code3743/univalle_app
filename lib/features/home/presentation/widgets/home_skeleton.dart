import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import 'quick_access_skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ShimmerBox.circle(36),
            const SizedBox(width: AppSpacing.sm),
            const ShimmerBox(width: 140, height: 16),
            const Spacer(),
            const ShimmerBox.circle(24),
            const SizedBox(width: AppSpacing.sm),
            const ShimmerBox.circle(36),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(width: 100, height: 16),
        const SizedBox(height: 8),
        const ShimmerBox(width: 200, height: 28),
        const SizedBox(height: 8),
        const ShimmerBox(width: 160, height: 14),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(height: 150, radius: 24),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 108, radius: 20)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: ShimmerBox(height: 108, radius: 20)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(width: 120, height: 20),
        const SizedBox(height: AppSpacing.sm),
        const QuickAccessSkeleton(),
      ],
    );
  }
}
