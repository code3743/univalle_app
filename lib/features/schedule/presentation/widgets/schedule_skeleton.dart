import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer/shimmer_box.dart';
import '../../../../core/widgets/shimmer/skeleton_list.dart';

class ScheduleSkeleton extends StatelessWidget {
  const ScheduleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 6; i++) ...[
              const Expanded(child: ShimmerBox(height: 20)),
              if (i != 5) const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Expanded(child: SkeletonList(itemCount: 4, itemHeight: 80)),
      ],
    );
  }
}
