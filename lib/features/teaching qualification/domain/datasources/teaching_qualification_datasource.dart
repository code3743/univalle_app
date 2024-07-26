import 'package:univalle_app/features/teaching%20qualification/domain/entities/subject_teacher.dart';

abstract class TeachingQualificationDataSource {
  Future<List<SubjectTeacher>> getTeachingQualifications();
  Future<void> createTeachingQualification(SubjectTeacher subjectTeacher);
}
