import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/widgets.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurante'),
      ),
      backgroundColor: AppColors.primaryRed,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      AccumulatedLunches(accumulated: 10),
                      const SizedBox(height: 10),
                      TicketItem(
                          title: 'Tipo de vinculación',
                          value: 'Estudiante',
                          icon: Icons.person),
                      TicketItem(
                        title: 'Valor del almuerzo',
                        value: '3.000',
                        icon: Icons.restaurant_rounded,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: AppColors.grey,
                          thickness: 1,
                        ),
                      ),
                      const Text('Comprar almuerzos',
                          style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      BuyLunchs(
                        minLunches: 3,
                        maxLunches: 83,
                        lunchPrice: 3000,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: AppColors.grey,
                          thickness: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            'Esta aplicación no recauda dinero ni procesa pagos. Se te proporcionará un enlace para que te dirijas al sitio oficial de la universidad y completes el pago de los almuerzos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SeparatorTicket()
            ],
          ),
        ),
      ),
    );
  }
}
