import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/teaching_rating/data/models/review_question_model.dart';
import 'package:univalle_app/features/teaching_rating/data/models/teacher_review_model.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';

void main() {
  test('toEntity maps every field, including nested questions', () {
    final model = TeacherReviewModel(
      formFields: const {'id_evaluacion': '42'},
      questions: [
        ReviewQuestionModel(
          id: 'q1',
          category: QuestionCategory.teacher,
          question: '¿El docente explica con claridad?',
        ),
      ],
      teacherName: 'Ana Ríos',
      subjectName: 'Cálculo',
    );

    final entity = model.toEntity();

    expect(entity.formFields, {'id_evaluacion': '42'});
    expect(entity.teacherName, 'Ana Ríos');
    expect(entity.subjectName, 'Cálculo');
    expect(entity.questions, hasLength(1));
    expect(entity.questions.single.id, 'q1');
    expect(entity.questions.single.category, QuestionCategory.teacher);
  });
}
