class QuestionsSubject {
  final String id;
  final String category;
  final String question;
  Rating? rating;

  QuestionsSubject({
    required this.id,
    required this.category,
    required this.question,
    this.rating,
  });
}

//Totalmente en desacuerdo	En desacuerdo	Medianamente de acuerdo	De acuerdo	Totalmente de acuerdo	No Aplica
enum Rating {
  totallyDisagree,
  disagree,
  somewhatAgree,
  agree,
  totallyAgree,
  notApply
}
