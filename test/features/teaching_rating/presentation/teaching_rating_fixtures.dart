import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';

class MockTeachingRatingRepository extends Mock
    implements TeachingRatingRepository {}

TeacherToRate teacher({
  String id = '1',
  String name = 'Ana Gómez',
  String subject = 'Cálculo',
  bool isQualified = false,
  String? novelty,
}) => TeacherToRate(
  id: id,
  teacherName: name,
  subjectName: subject,
  subjectCode: 'MAT1',
  group: '01',
  campusId: 'c',
  teacherId: 't',
  teacherDocument: 'd',
  programId: 'p',
  programName: 'Sistemas',
  programCode: 'pc',
  isQualified: isQualified,
  novelty: novelty,
);

const question1 = ReviewQuestion(
  id: 'q1',
  category: QuestionCategory.subject,
  question: '¿Pregunta uno?',
);
const question2 = ReviewQuestion(
  id: 'q2',
  category: QuestionCategory.teacher,
  question: '¿Pregunta dos?',
);

const review = TeacherReview(
  formFields: {'id_evaluacion': '99'},
  questions: [question1, question2],
  teacherName: 'Ana Gómez',
  subjectName: 'Cálculo',
);
