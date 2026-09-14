import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/teaching_rating/data/models/teacher_to_rate_model.dart';

void main() {
  test('toEntity maps every field, including an absent novelty', () {
    final model = TeacherToRateModel(
      id: '1',
      teacherName: 'Ana Ríos',
      subjectName: 'Cálculo',
      subjectCode: '101',
      group: '1',
      campusId: 'M',
      teacherId: 't1',
      teacherDocument: 'd1',
      programId: 'p1',
      programName: 'Ing. Sistemas',
      programCode: '752',
      isQualified: true,
    );

    final entity = model.toEntity();

    expect(entity.id, '1');
    expect(entity.teacherName, 'Ana Ríos');
    expect(entity.subjectCode, '101');
    expect(entity.isQualified, isTrue);
    expect(entity.novelty, isNull);
  });

  test('toEntity maps a present novelty', () {
    final model = TeacherToRateModel(
      id: '1',
      teacherName: 'Ana Ríos',
      subjectName: 'Cálculo',
      subjectCode: '101',
      group: '1',
      campusId: 'M',
      teacherId: 't1',
      teacherDocument: 'd1',
      programId: 'p1',
      programName: 'Ing. Sistemas',
      programCode: '752',
      isQualified: false,
      novelty: 'Docente no calificable',
    );

    final entity = model.toEntity();

    expect(entity.isQualified, isFalse);
    expect(entity.novelty, 'Docente no calificable');
  });
}
