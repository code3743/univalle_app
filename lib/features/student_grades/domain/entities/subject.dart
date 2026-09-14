class Subject {
  final String code;
  final String group;
  final String name;
  final int credits;
  final String grade;
  final bool isCanceled;
  final String campusId;

  const Subject({
    required this.code,
    required this.group,
    required this.name,
    required this.credits,
    required this.grade,
    required this.isCanceled,
    required this.campusId,
  });
}
