import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/curriculum_subject.dart';
import 'related_subject_tile.dart';

class RelationSection extends StatelessWidget {
  const RelationSection({
    super.key,
    required this.title,
    required this.subjects,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.directionIcon,
    required this.onTap,
  });

  final String title;
  final List<CurriculumSubject> subjects;
  final String emptyMessage;
  final IconData emptyIcon;
  final IconData directionIcon;
  final ValueChanged<CurriculumSubject> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (subjects.isEmpty)
          Row(
            children: [
              Icon(emptyIcon, size: 18, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          )
        else
          for (final relatedSubject in subjects)
            RelatedSubjectTile(
              subject: relatedSubject,
              directionIcon: directionIcon,
              onTap: () => onTap(relatedSubject),
            ),
      ],
    );
  }
}
