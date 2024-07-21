import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/entities/subject.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/student_grades_provider.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_overview.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/period_grades_list.dart';

class StudentGradesScreen extends ConsumerWidget {
  const StudentGradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentGrade = ref.watch(studentGradesProvider);
    final studentGradeNotifier = ref.read(studentGradesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
        elevation: 2,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: studentGrade == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryRed)),
                  SizedBox(height: 10),
                  Text(
                    'Consultando calificaciones...',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed),
                  )
                ],
              )
            : Column(
                children: [
                  PeriodGradesList(
                    periods: studentGradeNotifier.periods,
                    onPeriodSelected: studentGradeNotifier.filterGrades,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final grades = studentGrade[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: GradesOverview(
                              grade: Grades(
                                  period: grades.period,
                                  average: grades.average,
                                  credits: grades.credits,
                                  porcentageApproved: grades.porcentageApproved,
                                  subjects: [
                                    for (var subject in grades.subjects)
                                      Subject(
                                          name: subject.name,
                                          code: subject.code,
                                          group: subject.group,
                                          credits: subject.credits,
                                          grade: subject.grade,
                                          isCanceled: subject.isCanceled,
                                          isEnabled: subject.isEnabled)
                                  ],
                                  isWorthy: grades.isWorthy),
                            ));
                      },
                      itemCount: studentGrade.length,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
