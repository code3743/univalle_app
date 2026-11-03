import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';

class PeriodHeaderDivider extends StatelessWidget {
  const PeriodHeaderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: SizedBox(
        height: 28,
        child: VerticalDivider(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
