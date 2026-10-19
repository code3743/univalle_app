import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/features/resolution/presentation/utils/subject_area_style.dart';
import 'package:univalle_app/features/resolution/resolution_strings.dart';

void main() {
  test('maps electives', () {
    final style = SubjectAreaStyle.from('Electiva Complementaria');

    expect(style.area, SubjectArea.elective);
    expect(style.color, AppColors.accentPurple);
    expect(style.label, ResolutionStrings.subjectAreaElective);
  });

  test('maps professional and disciplinary subjects', () {
    expect(SubjectAreaStyle.from('Profesional').area, SubjectArea.professional);
    expect(SubjectAreaStyle.from('Disciplinar').area, SubjectArea.professional);
  });

  test('maps basic subjects with or without the accent', () {
    expect(SubjectAreaStyle.from('Básica').area, SubjectArea.basic);
    expect(SubjectAreaStyle.from('basica').area, SubjectArea.basic);
    expect(SubjectAreaStyle.from('Fundamentación').area, SubjectArea.basic);
  });

  test('keeps the raw text for unknown types', () {
    final style = SubjectAreaStyle.from('Lengua extranjera');

    expect(style.area, SubjectArea.other);
    expect(style.label, 'Lengua extranjera');
  });

  test('falls back to a generic label for an empty type', () {
    expect(SubjectAreaStyle.from('').label, ResolutionStrings.subjectAreaOther);
  });
}
