import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/student_grades_provider.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_overview.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/period_grades_list.dart';
import 'package:univalle_app/core/common/widgets/widgets.dart';

class StudentGradesScreen extends StatelessWidget {
  const StudentGradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPeriod = ValueNotifier<int>(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
        elevation: 2,
      ),
      body: Consumer(builder: (_, ref, __) {
        return FutureBuilder(
            future: ref.watch(studentGradesProvider.future),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: WidgetError( message: 'Ocurrió un error',
                        onRetry: () {
                         final _ = ref.refresh(studentGradesProvider);
                        }),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Center(child: LoadingWidget()),);
              }
              final grades = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  PeriodGradesList(
                    initialValue: currentPeriod.value,
                    periods: ['Todos', ...grades.map((e) => e.period)],
                    onChanged: (value) => currentPeriod.value = value,
                  ),
                  ValueListenableBuilder(
                      valueListenable: currentPeriod,
                      builder: (context, value, __) {
                        return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          final grade = grades[value == 0 ? index : value - 1];
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: GradesOverview(grade: grade));
                        }, childCount: value == 0 ? grades.length : 1));
                      }),
                ],
              );
            });
      }),
    );
  }
}
