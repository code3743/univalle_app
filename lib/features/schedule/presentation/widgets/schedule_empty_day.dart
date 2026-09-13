import 'package:flutter/material.dart';

import '../../schedule_strings.dart';

/// Friendly placeholder shown when there's nothing to display, instead of a
/// bare empty list — e.g. the selected day has no classes.
class ScheduleEmptyDay extends StatelessWidget {
  const ScheduleEmptyDay({
    super.key,
    this.message = ScheduleStrings.noClassesThisDay,
    this.icon = Icons.free_breakfast_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
