import '../../domain/entities/student.dart';

class StudentModel {
  final String documentId;
  final String firstName;
  final String lastName;
  final String email;
  final String programName;
  final String campus;
  final double average;
  final int accumulatedCredits;

  const StudentModel({
    required this.documentId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.programName,
    required this.campus,
    required this.average,
    required this.accumulatedCredits,
  });

  Student toEntity() => Student(
        documentId: documentId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        programName: programName,
        campus: campus,
        average: average,
        accumulatedCredits: accumulatedCredits,
      );
}
