import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/curriculum.dart';
import '../../resolution_strings.dart';
import 'subject_card.dart';

class SemesterSection extends StatelessWidget {
  const SemesterSection({
    super.key,
    required this.curriculum,
    required this.semester,
  });

  final Curriculum curriculum;
  final int semester;

  @override
  Widget build(BuildContext context) {
    final subjects = curriculum.subjectsInSemester(semester);
    final credits = curriculum.creditsInSemester(semester);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ResolutionStrings.semesterTitle(semester),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${subjects.length} · $credits ${ResolutionStrings.creditsUnit}',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final (index, subject) in subjects.indexed) ...[
          SubjectCard(curriculum: curriculum, subject: subject),
          if (index != subjects.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
