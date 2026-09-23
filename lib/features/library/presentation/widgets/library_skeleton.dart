import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import '../../../../core/widgets/shimmer/skeleton_list.dart';

class LibrarySkeleton extends StatelessWidget {
  const LibrarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(height: 76, width: double.infinity, radius: 20),
        const SizedBox(height: AppSpacing.lg),
        const ShimmerBox(height: 32, width: double.infinity),
        const SizedBox(height: AppSpacing.md),
        const Expanded(child: SkeletonList()),
      ],
    );
  }
}
