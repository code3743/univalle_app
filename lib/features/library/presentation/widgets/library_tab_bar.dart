import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../library_strings.dart';

class LibraryTabBar extends StatelessWidget {
  const LibraryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(12),
        labelColor: AppColors.univalleRed,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: LibraryStrings.loansTab),
          Tab(text: LibraryStrings.historyTab),
        ],
      ),
    );
  }
}
