import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';

class RestaurantSkeleton extends StatelessWidget {
  const RestaurantSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 14, width: 220),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 260, width: double.infinity, radius: 24),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(height: 56, width: double.infinity, radius: 20),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(height: 14, width: 260),
      ],
    );
  }
}
