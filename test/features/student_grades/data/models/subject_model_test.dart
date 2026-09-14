import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/student_grades/data/models/subject_model.dart';

void main() {
  test('toEntity maps every field', () {
    const model = SubjectModel(
      code: '101',
      group: '1',
      name: 'Cálculo',
      credits: 4,
      grade: '4.5',
      isCanceled: true,
      campusId: 'M',
    );

    final entity = model.toEntity();

    expect(entity.code, '101');
    expect(entity.group, '1');
    expect(entity.name, 'Cálculo');
    expect(entity.credits, 4);
    expect(entity.grade, '4.5');
    expect(entity.isCanceled, isTrue);
    expect(entity.campusId, 'M');
  });
}
