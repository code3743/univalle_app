import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/shimmer/shimmer_box.dart';

class MenuSkeleton extends StatelessWidget {
  const MenuSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 220, width: double.infinity, radius: 24),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
