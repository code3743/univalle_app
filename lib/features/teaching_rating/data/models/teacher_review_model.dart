import '../../domain/entities/teacher_review.dart';
import 'review_question_model.dart';

class TeacherReviewModel {
  final Map<String, String> formFields;
  final List<ReviewQuestionModel> questions;
  final String teacherName;
  final String subjectName;

  TeacherReviewModel({
    required this.formFields,
    required this.questions,
    required this.teacherName,
    required this.subjectName,
  });

  TeacherReview toEntity() => TeacherReview(
    formFields: formFields,
    questions: questions.map((question) => question.toEntity()).toList(),
    teacherName: teacherName,
    subjectName: subjectName,
  );
}
