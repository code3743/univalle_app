import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryRed,
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
          icon: Icon(Icons.notifications_rounded),
          label: 'Novedades',
        ),
      ],
    );
  }
}
