import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/teaching_rating/data/models/review_question_model.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';

void main() {
  test('toEntity maps every field', () {
    final model = ReviewQuestionModel(
      id: 'q1',
      category: QuestionCategory.student,
      question: '¿Consideras adecuada tu dedicación al curso?',
    );

    final entity = model.toEntity();

    expect(entity.id, 'q1');
    expect(entity.category, QuestionCategory.student);
    expect(entity.question, '¿Consideras adecuada tu dedicación al curso?');
  });
}
