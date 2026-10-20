import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import 'quick_access_skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerBox.circle(36),
            SizedBox(width: AppSpacing.sm),
            ShimmerBox(width: 140, height: 16),
            Spacer(),
            ShimmerBox.circle(24),
            SizedBox(width: AppSpacing.sm),
            ShimmerBox.circle(36),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(width: 100, height: 16),
        SizedBox(height: 8),
        ShimmerBox(width: 200, height: 28),
        SizedBox(height: 8),
        ShimmerBox(width: 160, height: 14),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(height: 150, radius: 24),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 108, radius: 20)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: ShimmerBox(height: 108, radius: 20)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(width: 120, height: 20),
        SizedBox(height: AppSpacing.sm),
        QuickAccessSkeleton(),
      ],
    );
  }
}
