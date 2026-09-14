import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum_subject.dart';

CurriculumSubject _subject({
  required String code,
  int semester = 1,
  int credits = 3,
  List<String> prerequisiteCodes = const [],
}) {
  return CurriculumSubject(
    code: code,
    name: 'Subject $code',
    subjectType: 'Fundamentación',
    credits: credits,
    semester: semester,
    prerequisiteCodes: prerequisiteCodes,
  );
}

void main() {
  late CurriculumSubject algebra;
  late CurriculumSubject calculus;
  late CurriculumSubject physics;
  late Curriculum curriculum;

  setUp(() {
    algebra = _subject(code: '101', semester: 1, credits: 4);
    calculus = _subject(
      code: '102',
      semester: 2,
      credits: 5,
      prerequisiteCodes: ['101'],
    );
    physics = _subject(
      code: '103',
      semester: 2,
      credits: 3,
      prerequisiteCodes: ['101'],
    );
    curriculum = Curriculum(subjects: [algebra, calculus, physics]);
  });

  test('semesters returns the distinct semester numbers, sorted', () {
    expect(curriculum.semesters, [1, 2]);
  });

  test('subjectsInSemester filters subjects by semester', () {
    expect(curriculum.subjectsInSemester(2), [calculus, physics]);
    expect(curriculum.subjectsInSemester(3), isEmpty);
  });

  test('creditsInSemester sums the credits of that semester\'s subjects', () {
    expect(curriculum.creditsInSemester(1), 4);
    expect(curriculum.creditsInSemester(2), 8);
  });

  test('prerequisitesOf resolves prerequisite codes to their subjects', () {
    expect(curriculum.prerequisitesOf(calculus), [algebra]);
    expect(curriculum.prerequisitesOf(algebra), isEmpty);
  });

  test(
    'prerequisitesOf ignores a prerequisite code with no matching subject',
    () {
      final orphan = _subject(
        code: '104',
        semester: 3,
        prerequisiteCodes: ['does-not-exist'],
      );
      final curriculumWithOrphan = Curriculum(
        subjects: [algebra, calculus, physics, orphan],
      );

      expect(curriculumWithOrphan.prerequisitesOf(orphan), isEmpty);
    },
  );

  test('unlockedBy returns every subject that lists it as a prerequisite', () {
    expect(curriculum.unlockedBy(algebra), [calculus, physics]);
  });

  test('unlockedBy returns an empty list when nothing depends on it', () {
    expect(curriculum.unlockedBy(calculus), isEmpty);
  });
}
