import 'package:flutter/material.dart';

import '../../domain/entities/weekday.dart';
import '../../schedule_strings.dart';

class ScheduleDaySelector extends StatelessWidget {
  const ScheduleDaySelector({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onSelected,
  });

  final List<Weekday> days;
  final Weekday selectedDay;
  final ValueChanged<Weekday> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          for (final day in days)
            Expanded(
              child: _DayLabel(
                label: ScheduleStrings.weekdayShortLabel(day),
                isSelected: day == selectedDay,
                onTap: () => onSelected(day),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
