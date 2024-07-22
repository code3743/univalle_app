import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/home/presentation/providers/logout_provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            SvgPicture.asset('assets/svg/logo.svg', height: 80),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: '¡Bienvenido a ',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Univalle App',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed)),
                      TextSpan(
                          text:
                              '! Esta aplicación móvil ha sido desarrollada para mejorar la experiencia de los estudiantes de la Universidad del Valle, proporcionando acceso fácil y rápido a diversos servicios universitarios desde sus dispositivos móviles.'),
                    ],
                  ),
                )),
            SizedBox(
              height: 150,
              child: Image.asset('assets/img/uv_ardilla.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Este es un proyecto ',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Open Source',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryRed)),
                    TextSpan(
                        text:
                            ' hecho por estudiantes, para estudiantes. ¡Únete a nosotros y contribuye al desarrollo de la comunidad universitaria!'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Consumer(builder: (_, ref, __) {
              return ListTile(
                iconColor: AppColors.primaryRed,
                textColor: AppColors.primaryRed,
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar Sesión'),
                onTap: () => ref.read(logoutProvider),
              );
            }),
            ListTile(
              iconColor: AppColors.primaryBlue,
              textColor: AppColors.primaryBlue,
              leading: const Icon(Icons.info),
              title: const Text('Términos y Condiciones'),
              onTap: () {},
            ),
            ListTile(
              iconColor: AppColors.primaryBlue,
              textColor: AppColors.primaryBlue,
              leading: const Icon(Icons.privacy_tip),
              title: const Text('GitHub'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
