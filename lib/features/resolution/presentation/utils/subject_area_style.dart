import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Maps SIRA's raw, free-text subject-type column to a small curated set of
/// curriculum areas so the UI can color-code by area without depending on
/// the exact wording SIRA happens to use.
enum SubjectArea { basic, professional, elective, other }

class SubjectAreaStyle {
  final SubjectArea area;
  final Color color;
  final String label;

  const SubjectAreaStyle._(this.area, this.color, this.label);

  factory SubjectAreaStyle.from(String rawSubjectType) {
    final normalized = rawSubjectType.toLowerCase();

    if (normalized.contains('electiv')) {
      return const SubjectAreaStyle._(
        SubjectArea.elective,
        AppColors.accentPurple,
        'Electiva',
      );
    }
    if (normalized.contains('profesional') ||
        normalized.contains('disciplinar')) {
      return const SubjectAreaStyle._(
        SubjectArea.professional,
        AppColors.accentBlue,
        'Formación profesional',
      );
    }
    if (normalized.contains('básica') ||
        normalized.contains('basica') ||
        normalized.contains('fundament')) {
      return const SubjectAreaStyle._(
        SubjectArea.basic,
        AppColors.accentGreen,
        'Formación básica',
      );
    }
    return SubjectAreaStyle._(
      SubjectArea.other,
      AppColors.accentPink,
      rawSubjectType.isEmpty ? 'Otra' : rawSubjectType,
    );
  }
}
