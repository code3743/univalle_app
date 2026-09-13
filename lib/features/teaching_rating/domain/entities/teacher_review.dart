import 'review_question.dart';

/// The evaluation form for one [TeacherToRate] assignment.
///
/// [formFields] are opaque hidden-input values SIRA embeds in the form
/// (evaluation id, period, student/subject codes, etc.) that must be sent
/// back verbatim alongside the answers for the submission to be accepted.
class TeacherReview {
  final Map<String, String> formFields;
  final List<ReviewQuestion> questions;
  final String teacherName;
  final String subjectName;

  const TeacherReview({
    required this.formFields,
    required this.questions,
    required this.teacherName,
    required this.subjectName,
  });
}
