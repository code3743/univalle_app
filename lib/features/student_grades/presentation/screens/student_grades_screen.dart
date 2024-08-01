import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/student_grades_provider.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_overview.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/period_grades_list.dart';

class StudentGradesScreen extends ConsumerWidget {
  const StudentGradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentGrades = ref.watch(studentGradesProvider);
    final studentGradesNotifer = ref.read(studentGradesProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
        elevation: 2,
      ),
      endDrawer: Drawer(
        backgroundColor: AppColors.white,
        child: ListView.builder(
          itemBuilder: (_, index) {
            return ListTile(
              selectedColor: AppColors.primaryBlue,
              title: Text(studentGradesNotifer.periods[index]),
              leading: Icon(
                studentGradesNotifer.selectedPeriod == index
                    ? Icons.circle
                    : Icons.circle_outlined,
                color: AppColors.primaryBlue,
              ),
              selected: studentGradesNotifer.selectedPeriod == index,
              onTap: () => studentGradesNotifer.filterGrades(index),
            );
          },
          itemCount: studentGradesNotifer.periods.length,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          PeriodGradesList(
            initialValue: studentGradesNotifer.selectedPeriod,
            periods: studentGradesNotifer.periods,
            onChanged: (value) => studentGradesNotifer.filterGrades(value),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            if (studentGrades == null) {
              //TODO: Implement shimmer animation
              return Container();
            }
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: GradesOverview(grade: studentGrades[index]));
          }, childCount: studentGrades?.length ?? 1)),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          )
        ],
      ),
    );
  }
}
