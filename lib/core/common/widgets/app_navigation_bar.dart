import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar(
      {super.key, required this.initialIndex, required this.onIndexChange});

  final int initialIndex;
  final ValueChanged<int> onIndexChange;

  @override
  Widget build(BuildContext context) {
    final currentIndex = ValueNotifier<int>(initialIndex);
    return ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (_, value, __) {
          return BottomNavigationBar(
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryRed,
            onTap: (value) {
              if (initialIndex > 0 && value == 0) return;
              onIndexChange(value);
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
