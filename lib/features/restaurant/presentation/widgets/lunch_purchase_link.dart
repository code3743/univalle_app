import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';

class LunchPurchaseLink extends StatelessWidget {
  const LunchPurchaseLink({super.key, required this.setPaymentProcess});
  final Future<PaymentProcess> setPaymentProcess;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        height: 150,
        child: FutureBuilder(
            future: setPaymentProcess,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryRed,
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cerrar'))
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enlace generado correctamente',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        //TODO: Launch URL
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Pagar'))
                ],
              );
            }),
      ),
    );
  }
}
