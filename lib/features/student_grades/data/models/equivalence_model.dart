import '../../domain/entities/equivalence.dart';

class EquivalenceModel {
  final String code;
  final String name;
  final String grade;
  final String typology;
  final String component;
  final int credits;

  const EquivalenceModel({
    required this.code,
    required this.name,
    required this.grade,
    required this.typology,
    required this.component,
    required this.credits,
  });

  Equivalence toEntity() => Equivalence(
    code: code,
    name: name,
    grade: grade,
    typology: typology,
    component: component,
    credits: credits,
  );
}
