import 'package:flutter/material.dart';

import '../../../../core/widgets/grade_value.dart';
import '../../domain/entities/equivalence.dart';
import '../../student_grades_strings.dart';

class EquivalenceTile extends StatelessWidget {
  const EquivalenceTile({super.key, required this.equivalence});

  final Equivalence equivalence;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(
        equivalence.name,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${equivalence.code} · ${equivalence.credits} '
        '${StudentGradesStrings.creditsUnit} · ${equivalence.typology}',
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: GradeValue(rawGrade: equivalence.grade),
    );
  }
}
