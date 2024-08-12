import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ValueNotifier<int>(0);
    return ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, value, _) {
          return BottomNavigationBar(
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryRed,
            onTap: (value) async {
              final isLogged =
                  await ref.read(studentUseCasesProvider).isLogged();
              switch (value) {
                case 0:
                  if (!isLogged) return;
                  ref.read(appRouterProvider).go('/home');
                  break;
                case 1:
                  ref.read(appRouterProvider).go('/subject-search');
                  break;
                case 2:
                default:
                  break;
              }
              currentIndex.value = value;
            },
            currentIndex: value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Asignaturas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_rounded),
                label: 'Interés',
              ),
            ],
          );
        });
  }
}
