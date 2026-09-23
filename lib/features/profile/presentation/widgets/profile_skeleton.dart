import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: ShimmerBox.circle(112)),
        const SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < 5; i++) const _InfoTileSkeleton(),
      ],
    );
  }
}

class _InfoTileSkeleton extends StatelessWidget {
  const _InfoTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const ShimmerBox.circle(24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 160, height: 16),
                const SizedBox(height: 6),
                const ShimmerBox(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
