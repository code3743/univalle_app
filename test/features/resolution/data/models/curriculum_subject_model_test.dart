import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/resolution/data/models/curriculum_subject_model.dart';

void main() {
  test('toEntity maps every field, including prerequisite codes', () {
    final model = CurriculumSubjectModel(
      code: '101',
      name: 'Cálculo',
      subjectType: 'Fundamentación',
      credits: 4,
      semester: 1,
      prerequisiteCodes: ['090'],
    );

    final entity = model.toEntity();

    expect(entity.code, '101');
    expect(entity.name, 'Cálculo');
    expect(entity.subjectType, 'Fundamentación');
    expect(entity.credits, 4);
    expect(entity.semester, 1);
    expect(entity.prerequisiteCodes, ['090']);
  });
}
