class TeachingRating {
  final String id;
  final String teacherName;
  final String subjectName;
  final String code;
  final String group;
  final String campusId;
  final String teacherId;
  final String teacherDocument;
  final String programId;
  final String programName;
  final String programCode;
  final bool isQualified;
  final String? novelty;

  TeachingRating({
    required this.id,
    required this.teacherName,
    required this.subjectName,
    required this.code,
    required this.group,
    required this.campusId,
    required this.teacherId,
    required this.teacherDocument,
    required this.programId,
    required this.programName,
    required this.programCode,
    required this.isQualified,
    this.novelty,
  });
}
