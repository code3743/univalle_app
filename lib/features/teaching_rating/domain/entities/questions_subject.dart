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
  totallyDisagree('Totalmente en desacuerdo'),
  disagree('En desacuerdo'),
  somewhatAgree('Medianamente de acuerdo'),
  agree('De acuerdo'),
  totallyAgree('Totalmente de acuerdo'),
  notApply('No Aplica');

  final String label;
  const Rating(this.label);

  @override
  toString() => label;
}
