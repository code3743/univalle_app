import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/schedule/data/models/schedule_class_model.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';

void main() {
  test('toEntity maps every field, including an absent teacherEmail', () {
    const model = ScheduleClassModel(
      subjectCode: '101',
      subjectName: 'Cálculo',
      group: '1',
      teacher: 'Ana Ríos',
      day: Weekday.monday,
      startTime: '07:00',
      endTime: '09:00',
      building: 'B13',
      room: '101',
      campus: 'Meléndez',
    );

    final entity = model.toEntity();

    expect(entity.subjectCode, '101');
    expect(entity.teacher, 'Ana Ríos');
    expect(entity.teacherEmail, isNull);
    expect(entity.day, Weekday.monday);
    expect(entity.startTime, '07:00');
    expect(entity.endTime, '09:00');
    expect(entity.building, 'B13');
    expect(entity.room, '101');
    expect(entity.campus, 'Meléndez');
  });

  test('toEntity maps a present teacherEmail', () {
    const model = ScheduleClassModel(
      subjectCode: '101',
      subjectName: 'Cálculo',
      group: '1',
      teacher: 'Ana Ríos',
      teacherEmail: 'ana.rios@correounivalle.edu.co',
      day: Weekday.tuesday,
      startTime: '07:00',
      endTime: '09:00',
      building: 'B13',
      room: '101',
      campus: 'Meléndez',
    );

    expect(model.toEntity().teacherEmail, 'ana.rios@correounivalle.edu.co');
  });
}
