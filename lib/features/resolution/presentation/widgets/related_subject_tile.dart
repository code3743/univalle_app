import 'package:flutter/material.dart';

import '../../domain/entities/curriculum_subject.dart';
import '../utils/subject_area_style.dart';

class RelatedSubjectTile extends StatelessWidget {
  const RelatedSubjectTile({
    super.key,
    required this.subject,
    required this.directionIcon,
    required this.onTap,
  });

  final CurriculumSubject subject;
  final IconData directionIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final areaStyle = SubjectAreaStyle.from(subject.subjectType);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: areaStyle.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(directionIcon, size: 14, color: areaStyle.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subject.code,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
