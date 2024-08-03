import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/widgets/profile_picture.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/home/presentation/widgets/about_item.dart';

class StudentProfileInfo extends ConsumerWidget {
  const StudentProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final student = ref.read(studentUseCasesProvider).getStudent();
    return SizedBox(
      width: double.infinity,
      height: 320,
      child: Stack(
        children: [
          Container(
            height: 260,
            width: size.width,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const ProfilePicture(isEditable: true),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        '${student.fristName.split(' ')[0]} ${student.lastName.split(' ')[0]}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaler: TextScaler.noScaling),
                    Text(student.programName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.noScaling),
                    Text(student.studentId.substring(2),
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1),
                        textScaler: TextScaler.noScaling),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AboutItem(
                    title: 'Promedio',
                    value: student.average.toString(),
                    color: AppColors.orange,
                    icon: 'assets/svg/promedio.svg',
                  ),
                  AboutItem(
                    title: 'Créditos',
                    value: student.accumulatedCredits.toString(),
                    color: AppColors.green,
                    icon: 'assets/svg/creditos.svg',
                  ),
                  AboutItem(
                    title: 'Deudas',
                    value: student.studentFines.toString(),
                    color: AppColors.blue,
                    icon: 'assets/svg/deudas.svg',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
