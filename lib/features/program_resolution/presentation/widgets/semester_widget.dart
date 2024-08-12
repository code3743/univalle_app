import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/routers/app_router_name.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

class SemesterWidget extends StatelessWidget {
  const SemesterWidget({
    super.key,
    required this.subjectCycle,
  });
  final SubjectCycle subjectCycle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        context.push(AppRouterName.detailSemester, extra: subjectCycle);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryBlue,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${subjectCycle.semester}°',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Semestre',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SemesterAbout(
                    title: 'Créditos',
                    value: subjectCycle.totalCredits.toString(),
                  ),
                  SemesterAbout(
                    title: 'Asignaturas',
                    value: subjectCycle.subjects.length.toString(),
                  ),
                  SemesterAbout(
                    title: 'Pre-Requisitos',
                    value: subjectCycle.totalPreRequisites.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SemesterAbout extends StatelessWidget {
  const SemesterAbout({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              height: 1,
              fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 32,
              height: 1,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
