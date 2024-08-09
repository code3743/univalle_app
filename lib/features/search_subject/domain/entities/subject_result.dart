class SubjectResult {
  final String group;
  final String teacher;
  final String teacherEmail;
  final String program;
  final bool isGeneric;
  final bool isRepeater;
  final String schedule;
  final int capacity;

  SubjectResult({
    required this.group,
    required this.teacher,
    required this.teacherEmail,
    required this.program,
    required this.isGeneric,
    required this.isRepeater,
    required this.schedule,
    required this.capacity,
  });
}

class SearchResult {
  final String code;
  final String name;
  final int credits;
  final List<SubjectResult> results;

  SearchResult({
    required this.code,
    required this.name,
    required this.credits,
    required this.results,
  });
}
