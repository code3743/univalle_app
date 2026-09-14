import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../student_grades_strings.dart';

/// Renders a subject's raw grade text, parsing it only for display.
///
/// SIRA grade cells aren't always numeric (in-progress subjects, cancellations,
/// etc.), so the domain layer keeps [rawGrade] as-is. Here we try to parse a
/// 0-5 numeric grade to color it as failing/regular/outstanding; anything that
/// doesn't parse into that range is shown as-is in a neutral color.
class GradeValue extends StatelessWidget {
  const GradeValue({super.key, required this.rawGrade});

  final String rawGrade;

  static const _failingMax = 3.0;
  static const _regularMax = 4.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final grade = double.tryParse(rawGrade);
    final isValidGrade = grade != null && grade >= 0 && grade <= 5;

    return Text(
      rawGrade.isEmpty ? StudentGradesStrings.noGradeValue : rawGrade,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: isValidGrade ? _colorFor(grade, colorScheme) : colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Color _colorFor(double grade, ColorScheme colorScheme) {
    if (grade < _failingMax) return colorScheme.error;
    if (grade < _regularMax) return AppColors.accentAmber;
    return AppColors.accentGreen;
  }
}
