import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/domain/entities/subject.dart';
import 'package:univalle_app/features/student_grades/domain/entities/academic_history.dart';
import 'package:univalle_app/features/student_grades/domain/entities/equivalence.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';

class MockGradesRepository extends Mock implements GradesRepository {}

Subject subject({
  String name = 'CÁLCULO I',
  String grade = '4.2',
  bool isCanceled = false,
  int credits = 4,
}) => Subject(
  code: 'MAT1',
  group: '01',
  name: name,
  credits: credits,
  grade: grade,
  isCanceled: isCanceled,
  campusId: '1',
);

Grades period({
  String period = 'FEBRERO/2024 - JUNIO/2024',
  double average = 4.0,
  bool hasAcademicMerit = false,
  List<Subject>? subjects,
}) => Grades(
  period: period,
  average: average,
  credits: 16,
  approvedPercentage: '100%',
  hasAcademicMerit: hasAcademicMerit,
  subjects: subjects ?? [subject()],
);

const equivalence = Equivalence(
  code: '111021C',
  name: 'CÁLCULO MONOVARIABLE',
  grade: '3.6',
  typology: 'AB',
  component: 'SIN',
  credits: 3,
);

AcademicHistory history({
  List<Grades>? periods,
  List<Equivalence> equivalences = const [],
}) =>
    AcademicHistory(periods: periods ?? [period()], equivalences: equivalences);
