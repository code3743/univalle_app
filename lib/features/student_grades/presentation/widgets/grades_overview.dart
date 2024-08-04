import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_overview_item.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/subject_card.dart';

class GradesOverview extends StatelessWidget {
  const GradesOverview({
    super.key,
    required this.grade,
  });

  final Grades grade;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 40,
                width: 200,
                decoration: const BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                    child: Text(
                  grade.period.replaceAll('-', '\n'),
                  style: const TextStyle(
                      height: 1,
                      fontSize: 14,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ))),
            Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(
                        20), // This is the problem, it should be bottomRight
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GradesOverviewItem(
                              title: 'Promedio',
                              value: grade.average.toString()),
                          GradesOverviewItem(
                              title: 'Créditos',
                              value: grade.credits.toString()),
                          GradesOverviewItem(
                              title: 'Aprobado',
                              value: grade.porcentageApproved),
                        ],
                      ),
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: AppColors.lightGrey,
                        height: 0.5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: grade.subjects.length,
                      itemBuilder: (context, index) {
                        return SubjectCard(
                          subject: grade.subjects[index],
                        );
                      },
                    ),
                  ],
                )),
          ],
        ),
        if (grade.isWorthy)
          Positioned(
            top: 10,
            left: 180,
            child: SizedBox(
              height: 40,
              width: 40,
              child:
                  Image.asset('assets/img/uv_ardilla.png', fit: BoxFit.contain),
            ),
          ),
      ],
    );
  }
}
