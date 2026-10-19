import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum.dart';
import 'package:univalle_app/features/resolution/domain/entities/curriculum_subject.dart';
import 'package:univalle_app/features/resolution/domain/repositories/resolution_repository.dart';

class MockResolutionRepository extends Mock implements ResolutionRepository {}

const calculus = CurriculumSubject(
  code: 'MAT1',
  name: 'Cálculo I',
  subjectType: 'Formación básica',
  credits: 4,
  semester: 1,
  prerequisiteCodes: [],
);

const calculusTwo = CurriculumSubject(
  code: 'MAT2',
  name: 'Cálculo II',
  subjectType: 'Formación básica',
  credits: 1,
  semester: 2,
  prerequisiteCodes: ['MAT1'],
);

const elective = CurriculumSubject(
  code: 'ELE1',
  name: 'Electiva libre',
  subjectType: 'Electiva',
  credits: 2,
  semester: 2,
  prerequisiteCodes: ['MAT1', 'MAT2'],
);

Curriculum curriculum() =>
    Curriculum(subjects: const [calculus, calculusTwo, elective]);
