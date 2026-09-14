import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/profile/data/models/student_model.dart';

void main() {
  test('toEntity maps every field', () {
    const model = StudentModel(
      documentId: '123',
      firstName: 'Juan',
      lastName: 'Perez',
      email: 'jperez@correounivalle.edu.co',
      programName: 'Ingeniería de Sistemas',
      campus: 'Meléndez',
      average: 4.2,
      accumulatedCredits: 90,
    );

    final entity = model.toEntity();

    expect(entity.documentId, '123');
    expect(entity.firstName, 'Juan');
    expect(entity.lastName, 'Perez');
    expect(entity.email, 'jperez@correounivalle.edu.co');
    expect(entity.programName, 'Ingeniería de Sistemas');
    expect(entity.campus, 'Meléndez');
    expect(entity.average, 4.2);
    expect(entity.accumulatedCredits, 90);
  });
}
