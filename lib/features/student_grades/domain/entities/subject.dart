class Subject {
  final String name;
  final String code;
  final String group;
  final bool isCanceled;
  final double grade;
  final bool isEnabled;
  final int credits;
  late bool isApproved;
  Subject({
    required this.name,
    required this.code,
    required this.group,
    required this.isCanceled,
    required this.grade,
    required this.isEnabled,
    required this.credits,
  }) {
    isApproved = grade >= 3;
  }
}
