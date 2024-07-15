import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/home/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
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
                  onPressed: () {},
                  icon: 'assets/svg/calificacion.svg',
                ),
                ItemService(
                  title: 'Tabulado',
                  onPressed: () {},
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
                  onPressed: () {},
                  icon: 'assets/svg/calificacion_docente.svg',
                ),
                ItemService(
                  title: 'Carné digital',
                  onPressed: () {},
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
                  onPressed: () {},
                  icon: 'assets/svg/resolucion.svg',
                ),
                ItemService(
                  title: 'Restaurante',
                  onPressed: () {},
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

class _StudentProfileInfo extends StatelessWidget {
  const _StudentProfileInfo();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
            child: const Column(
              children: [
                Header(),
                Column(
                  children: [
                    ProfilePicture(isEditable: true),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Angie Tabares',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'LICENCIATURA EN HISTORIA',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text('1640614',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
                SizedBox(
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AboutItem(
                    title: 'Promedio',
                    value: '4.6',
                    color: AppColors.orange,
                    icon: 'assets/svg/promedio.svg',
                  ),
                  AboutItem(
                    title: 'Créditos',
                    value: '120',
                    color: AppColors.green,
                    icon: 'assets/svg/creditos.svg',
                  ),
                  AboutItem(
                    title: 'Dedudas',
                    value: '0',
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
