import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_empty_view.dart';
import '../../../domain/entities/weekly_menu.dart';
import '../../../restaurant_strings.dart';
import '../../utils/menu_category_style.dart';
import '../../utils/menu_day_selection.dart';
import 'menu_day_selector.dart';
import 'menu_dish_tile.dart';

class WeeklyMenuSection extends StatefulWidget {
  const WeeklyMenuSection({super.key, required this.menu, this.today});

  final WeeklyMenu menu;

  /// Overridable so tests don't depend on the real date.
  final DateTime? today;

  @override
  State<WeeklyMenuSection> createState() => _WeeklyMenuSectionState();
}

class _WeeklyMenuSectionState extends State<WeeklyMenuSection> {
  late int _selectedIndex = initialMenuDayIndex(
    widget.menu.days,
    widget.today ?? DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final day = widget.menu.days[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          RestaurantStrings.menuTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (widget.menu.weekLabel.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            '${widget.menu.weekLabel} · ${RestaurantStrings.menuSubjectToChange}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        MenuDaySelector(
          days: widget.menu.days,
          selectedIndex: _selectedIndex,
          onSelected: (index) => setState(() => _selectedIndex = index),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (day.isClosed)
          AppEmptyView(
            icon: Icons.event_busy_outlined,
            title: RestaurantStrings.noService(day.closedReason!),
          )
        else
          for (var i = 0; i < day.dishes.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: MenuDishTile(
                dish: day.dishes[i],
                accent: menuAccentFor(i),
              ),
            ),
      ],
    );
  }
}
