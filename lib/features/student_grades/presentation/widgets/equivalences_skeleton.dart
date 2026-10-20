import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import '../../../../core/widgets/shimmer/skeleton_list.dart';

class EquivalencesSkeleton extends StatelessWidget {
  const EquivalencesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 76, radius: 20)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: ShimmerBox(height: 76, radius: 20)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        SkeletonList(itemCount: 6, itemHeight: 56),
      ],
    );
  }
}
