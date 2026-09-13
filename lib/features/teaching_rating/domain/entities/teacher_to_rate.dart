/// One teacher+subject+group assignment the current student can evaluate.
/// The id fields are opaque SIRA identifiers carried through unchanged so
/// they can be replayed later when requesting that assignment's review form.
class TeacherToRate {
  final String id;
  final String teacherName;
  final String subjectName;
  final String subjectCode;
  final String group;
  final String campusId;
  final String teacherId;
  final String teacherDocument;
  final String programId;
  final String programName;
  final String programCode;
  final bool isQualified;
  final String? novelty;

  const TeacherToRate({
    required this.id,
    required this.teacherName,
    required this.subjectName,
    required this.subjectCode,
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
