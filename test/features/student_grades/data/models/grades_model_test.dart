import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/student_grades/data/models/grades_model.dart';
import 'package:univalle_app/features/student_grades/data/models/subject_model.dart';

void main() {
  test('toEntity maps every field, including nested subjects', () {
    const model = GradesModel(
      period: 'Feb/22 – Jun/22',
      average: 4.1,
      credits: 18,
      approvedPercentage: '100%',
      hasAcademicMerit: true,
      subjects: [
        SubjectModel(
          code: '101',
          group: '1',
          name: 'Cálculo',
          credits: 4,
          grade: '4.5',
          isCanceled: false,
          campusId: 'M',
        ),
      ],
    );

    final entity = model.toEntity();

    expect(entity.period, 'Feb/22 – Jun/22');
    expect(entity.average, 4.1);
    expect(entity.credits, 18);
    expect(entity.approvedPercentage, '100%');
    expect(entity.hasAcademicMerit, isTrue);
    expect(entity.subjects, hasLength(1));
    expect(entity.subjects.single.name, 'Cálculo');
  });
}
