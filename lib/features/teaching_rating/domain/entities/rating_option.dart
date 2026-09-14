/// Five-point agreement scale SIRA's evaluation form uses for every
/// question, plus a "not applicable" option. Sent back as `index + 1`.
enum RatingOption {
  totallyDisagree('Totalmente en desacuerdo'),
  disagree('En desacuerdo'),
  somewhatAgree('Medianamente de acuerdo'),
  agree('De acuerdo'),
  totallyAgree('Totalmente de acuerdo'),
  notApply('No Aplica');

  final String label;
  const RatingOption(this.label);
}
