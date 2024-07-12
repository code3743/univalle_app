class Student {
  final String fristName;
  final String lastName;
  final String email;
  final String campus;
  final String documentId;
  final String studentId;
  final String programId;
  final String programName;
  final double average;
  final int accumulatedCredits;
  final int studentFines;
  final String password;
  final String? pathToProfileImage;

  Student({
    required this.fristName,
    required this.lastName,
    required this.email,
    required this.campus,
    required this.documentId,
    required this.studentId,
    required this.programId,
    required this.programName,
    required this.average,
    required this.password,
    required this.accumulatedCredits,
    required this.studentFines,
    this.pathToProfileImage,
  });
}
