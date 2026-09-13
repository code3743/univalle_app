import 'package:flutter/material.dart';

import '../../domain/entities/schedule_class.dart';

class ScheduleClassTile extends StatelessWidget {
  const ScheduleClassTile({
    super.key,
    required this.scheduleClass,
    required this.accent,
  });

  final ScheduleClass scheduleClass;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final place = _placeText();

    return Material(
      color: Colors.white,
      shadowColor: accent,
      borderRadius: BorderRadius.circular(20),
      elevation: .1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.menu_book_rounded, size: 18, color: accent),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_to12Hour(scheduleClass.startTime)} - '
                    '${_to12Hour(scheduleClass.endTime)}',
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold, color: accent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scheduleClass.subjectName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (place.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _IconLine(icon: Icons.location_on_outlined, text: place),
                  ],
                  if (scheduleClass.teacher.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    _IconLine(
                      icon: Icons.person_outline,
                      text: scheduleClass.teacher,
                    ),
                  ],
                  if (scheduleClass.teacherEmail != null) ...[
                    const SizedBox(height: 2),
                    _IconLine(
                      icon: Icons.email_outlined,
                      text: scheduleClass.teacherEmail!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _placeText() {
    final parts = <String>[];
    if (scheduleClass.building.isNotEmpty) {
      parts.add('Edif. ${scheduleClass.building}');
    }
    if (scheduleClass.room.isNotEmpty) {
      parts.add(_titleCase(scheduleClass.room));
    }
    if (scheduleClass.campus.isNotEmpty) {
      parts.add(_titleCase(scheduleClass.campus));
    }
    return parts.join(' · ');
  }

  // The entity keeps 24h zero-padded times ("14:00") so sorting by string
  // stays chronological; this only converts them for display.
  String _to12Hour(String time24) {
    final parts = time24.split(':');
    final hour24 = int.parse(parts[0]);
    final period = hour24 >= 12 ? 'p.m' : 'a.m';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:${parts[1]} $period';
  }

  String _titleCase(String value) => value
      .split(' ')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
