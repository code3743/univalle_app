import 'package:flutter/material.dart';

/// Wraps a schedule card with the day-agenda's vertical timeline: a dot for
/// this class and a connecting line down to the next one.
class ScheduleTimelineTile extends StatelessWidget {
  const ScheduleTimelineTile({
    super.key,
    required this.accent,
    required this.isLast,
    required this.child,
  });

  final Color accent;
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: accent.withValues(alpha: 0.25),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
