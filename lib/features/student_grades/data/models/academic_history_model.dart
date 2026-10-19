import '../../domain/entities/academic_history.dart';
import 'equivalence_model.dart';
import 'grades_model.dart';

class AcademicHistoryModel {
  final List<GradesModel> periods;
  final List<EquivalenceModel> equivalences;

  const AcademicHistoryModel({
    required this.periods,
    required this.equivalences,
  });

  AcademicHistory toEntity() => AcademicHistory(
    periods: periods.map((period) => period.toEntity()).toList(),
    equivalences: equivalences.map((item) => item.toEntity()).toList(),
  );
}
