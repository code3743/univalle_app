enum QuestionCategory {
  subject('Asignatura'),
  teacher('Docente'),
  student('Estudiante');

  final String label;
  const QuestionCategory(this.label);
}

class ReviewQuestion {
  final String id;
  final QuestionCategory category;
  final String question;

  const ReviewQuestion({
    required this.id,
    required this.category,
    required this.question,
  });
}
