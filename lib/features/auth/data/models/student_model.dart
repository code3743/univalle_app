import 'package:univalle_app/core/domain/entities/student.dart';

class StudentModel {
  final String token;
  final String fristName;
  final String lastName;
  final String email;
  final String campus;
  final String documentId;
  final String studentId;
  final String programId;
  final String programName;
  final double average;
  final String password;
  final int accumulatedCredits;
  final int studentFines;
  final String? pathToProfileImage;

  StudentModel({
    required this.token,
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

  Student toEntity() => Student(
        token: token,
        fristName: fristName,
        lastName: lastName,
        email: email,
        campus: campus,
        documentId: documentId,
        studentId: studentId,
        programId: programId,
        programName: programName,
        average: average,
        password: password,
        pathToProfileImage: pathToProfileImage,
        accumulatedCredits: accumulatedCredits,
        studentFines: studentFines,
      );

  factory StudentModel.fromEntity(Student student) => StudentModel(
        token: student.token,
        fristName: student.fristName,
        lastName: student.lastName,
        email: student.email,
        documentId: student.documentId,
        studentId: student.studentId,
        programId: student.programId,
        programName: student.programName,
        average: student.average,
        password: student.password,
        pathToProfileImage: student.pathToProfileImage,
        campus: student.campus,
        accumulatedCredits: student.accumulatedCredits,
        studentFines: student.studentFines,
      );

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        token: json['token'],
        fristName: json['fristName'],
        lastName: json['lastName'],
        email: json['email'],
        campus: json['campus'],
        documentId: json['documentId'],
        studentId: json['studentId'],
        programId: json['programId'],
        programName: json['programName'],
        average: json['average'],
        password: json['password'],
        pathToProfileImage: json['pathToProfileImage'],
        accumulatedCredits: json['accumulatedCredits'],
        studentFines: json['studentFines'],
      );
}
