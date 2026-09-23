import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';

class RestaurantSkeleton extends StatelessWidget {
  const RestaurantSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerBox(height: 14, width: 220),
        const SizedBox(height: AppSpacing.md),
        const ShimmerBox(height: 260, width: double.infinity, radius: 24),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(height: 56, width: double.infinity, radius: 20),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(height: 14, width: 260),
      ],
    );
  }
}
