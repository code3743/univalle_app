import 'package:flutter/material.dart';

import '../../domain/entities/subject.dart';
import '../../student_grades_strings.dart';
import 'grade_value.dart';

class SubjectTile extends StatelessWidget {
  const SubjectTile({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtitle = StringBuffer(
      '${StudentGradesStrings.groupLabel} ${subject.group} · '
      '${subject.credits} ${StudentGradesStrings.creditsUnit}',
    );
    if (subject.isCanceled) {
      subtitle.write(' · ${StudentGradesStrings.canceledLabel}');
    }

    return ListTile(
      title: Text(
        subject.name,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: subject.isCanceled ? colorScheme.error : null,
          decoration: subject.isCanceled ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        subtitle.toString(),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: GradeValue(rawGrade: subject.grade),
    );
  }
}
