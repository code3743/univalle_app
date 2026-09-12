class CurriculumSubject {
  final String code;
  final String name;
  final String subjectType;
  final int credits;
  final int semester;
  final List<String> prerequisiteCodes;

  const CurriculumSubject({
    required this.code,
    required this.name,
    required this.subjectType,
    required this.credits,
    required this.semester,
    required this.prerequisiteCodes,
  });
}
