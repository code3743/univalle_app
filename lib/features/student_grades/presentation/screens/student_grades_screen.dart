import 'package:flutter/material.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/entities/subject.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_overview.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/period_grades_list.dart';

class StudentGradesScreen extends StatelessWidget {
  const StudentGradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
        elevation: 2,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const PeriodGradesList(periods: ['Todos', '2021-1']),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: GradesOverview(
                        grade: Grades(
                            period: '2021-1',
                            average: 3.5,
                            credits: 20,
                            porcentageApproved: '80%',
                            subjects: [
                              Subject(
                                  name: 'Matematicas',
                                  code: 'MAT-101',
                                  group: 'A',
                                  credits: 4,
                                  grade: 4.5,
                                  isCanceled: false,
                                  isEnabled: false),
                              Subject(
                                  name: 'Fisica',
                                  code: 'FIS-101',
                                  group: 'A',
                                  credits: 4,
                                  grade: 3.5,
                                  isCanceled: false,
                                  isEnabled: false),
                              Subject(
                                  name: 'Quimica',
                                  code: 'QUI-101',
                                  group: 'A',
                                  credits: 4,
                                  grade: 2.9,
                                  isCanceled: false,
                                  isEnabled: false),
                              Subject(
                                  name: 'Programacion',
                                  code: 'PRO-101',
                                  group: 'A',
                                  credits: 4,
                                  grade: 4.0,
                                  isCanceled: false,
                                  isEnabled: false),
                              Subject(
                                  name: 'Base de Datos',
                                  code: 'BD-101',
                                  group: 'A',
                                  credits: 4,
                                  grade: 3.5,
                                  isCanceled: false,
                                  isEnabled: false),
                              Subject(
                                  name: 'Ingles',
                                  code: 'ING-101',
                                  group: 'A',
                                  credits: 4,
                                  grade: 0,
                                  isCanceled: true,
                                  isEnabled: false),
                            ],
                            isWorthy: false),
                      ));
                },
                itemCount: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
