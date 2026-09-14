import 'curriculum_subject.dart';

/// The student's full academic plan, with prerequisite relationships
/// resolved against the other subjects in the same plan (SIRA only gives
/// prerequisite codes, not the subjects they point to).
class Curriculum {
  final List<CurriculumSubject> subjects;

  Curriculum({required this.subjects})
    : _byCode = {for (final subject in subjects) subject.code: subject},
      _dependentsByCode = _buildDependents(subjects);

  final Map<String, CurriculumSubject> _byCode;
  final Map<String, List<CurriculumSubject>> _dependentsByCode;

  static Map<String, List<CurriculumSubject>> _buildDependents(
    List<CurriculumSubject> subjects,
  ) {
    final dependents = <String, List<CurriculumSubject>>{};
    for (final subject in subjects) {
      for (final prerequisiteCode in subject.prerequisiteCodes) {
        dependents.putIfAbsent(prerequisiteCode, () => []).add(subject);
      }
    }
    return dependents;
  }

  List<int> get semesters {
    final numbers = subjects
        .map((subject) => subject.semester)
        .toSet()
        .toList();
    numbers.sort();
    return numbers;
  }

  List<CurriculumSubject> subjectsInSemester(int semester) =>
      subjects.where((subject) => subject.semester == semester).toList();

  int creditsInSemester(int semester) =>
      subjectsInSemester(semester)
          .fold(0, (sum, subject) => sum + subject.credits);

  /// The subjects [subject] requires before it can be taken.
  List<CurriculumSubject> prerequisitesOf(CurriculumSubject subject) => subject
      .prerequisiteCodes
      .map((code) => _byCode[code])
      .whereType<CurriculumSubject>()
      .toList();

  /// The subjects that list [subject] as one of their prerequisites.
  List<CurriculumSubject> unlockedBy(CurriculumSubject subject) =>
      _dependentsByCode[subject.code] ?? const [];
}
