import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/custom_button.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/ticket_item.dart';

class ConfirmLunchOrder extends StatelessWidget {
  const ConfirmLunchOrder({super.key, required this.total});
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      width: double.infinity,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Estás seguro de querer comprar estos almuerzos?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                  'Al confirmar la compra se generará un enlace para que '
                  'te dirijas al portal de pagos de la universidad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              TicketItem(
                  title: 'Total a pagar',
                  value: total.toStringAsFixed(0),
                  icon: Icons.monetization_on),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Confirmar',
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                backgroundColor: AppColors.primaryBlue,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                  text: 'Cancelar',
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  backgroundColor: AppColors.white,
                  textColor: AppColors.primaryBlue,
                  borderColor: AppColors.primaryBlue,
                  borderWidth: 2)
            ],
          ),
        ),
      ),
    );
  }
}
