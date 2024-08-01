import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/profile_picture.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/home/presentation/view/home_drawer.dart';
import 'package:univalle_app/features/home/presentation/widgets/custom_navigation_bar.dart';
import 'package:univalle_app/features/home/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      bottomNavigationBar: const CustomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _StudentProfileInfo(),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ItemService(
                  title: 'Calificaciones',
                  onPressed: () {
                    context.push('/home/student-grades');
                  },
                  icon: 'assets/svg/calificacion.svg',
                ),
                ItemService(
                  title: 'Tabulado',
                  onPressed: () {
                    context.push('/home/tabulate');
                  },
                  icon: 'assets/svg/tabulado.svg',
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ItemService(
                  title: 'Calificación docente',
                  onPressed: () {
                    context.push('/home/teaching-rating');
                  },
                  icon: 'assets/svg/calificacion_docente.svg',
                ),
                ItemService(
                  title: 'Carné digital',
                  onPressed: () {
                    context.push('/home/digital-card');
                  },
                  icon: 'assets/svg/carne_digital.svg',
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ItemService(
                  title: 'Resolución',
                  onPressed: () {
                    context.push('/home/resolution');
                  },
                  icon: 'assets/svg/resolucion.svg',
                ),
                ItemService(
                  title: 'Restaurante',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Este módulo está en desarrollo.'),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                  },
                  icon: 'assets/svg/restaurante.svg',
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentProfileInfo extends ConsumerWidget {
  const _StudentProfileInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final student = ref.watch(studentUseCasesProvider).getStudent();
    return SizedBox(
      width: size.width,
      height: 400,
      child: Stack(
        children: [
          Container(
            height: 350,
            width: size.width,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                const Header(),
                Column(
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
                    ),
                    Text(
                      student.programName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(student.studentId.substring(2),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              height: 105,
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
                    title: 'Dedudas',
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
