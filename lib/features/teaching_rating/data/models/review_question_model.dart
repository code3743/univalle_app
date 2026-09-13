import '../../domain/entities/review_question.dart';

class ReviewQuestionModel {
  final String id;
  final QuestionCategory category;
  final String question;

  ReviewQuestionModel({
    required this.id,
    required this.category,
    required this.question,
  });

  ReviewQuestion toEntity() =>
      ReviewQuestion(id: id, category: category, question: question);
}
