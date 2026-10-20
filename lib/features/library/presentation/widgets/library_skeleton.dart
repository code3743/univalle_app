import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import '../../../../core/widgets/shimmer/skeleton_list.dart';

class LibrarySkeleton extends StatelessWidget {
  const LibrarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(height: 76, width: double.infinity, radius: 20),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(height: 32, width: double.infinity),
        SizedBox(height: AppSpacing.md),
        Expanded(child: SkeletonList()),
      ],
    );
  }
}
