class SubjectResult {
  final String code;
  final String name;
  final String group;
  final String teacher;
  final String teacherEmail;
  final String program;
  final bool isGeneric;
  final bool isRepeater;
  final int credits;
  final String hours;

  SubjectResult({
    required this.code,
    required this.name,
    required this.group,
    required this.teacher,
    required this.teacherEmail,
    required this.program,
    required this.isGeneric,
    required this.isRepeater,
    required this.credits,
    required this.hours,
  });
}
