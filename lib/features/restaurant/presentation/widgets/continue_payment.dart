import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/common/widgets/custom_button.dart';
import 'package:univalle_app/features/restaurant/domain/entities/payment_process.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/ticket_item.dart';

class ContinuePayment extends StatelessWidget {
  const ContinuePayment({super.key, required this.paymentProcess});
  final PaymentProcess paymentProcess;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Compra en proceso',
            style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        TicketItem(
          title: 'Fecha de inicio',
          value: paymentProcess.startDate,
          icon: Icons.date_range,
        ),
        TicketItem(
          title: 'Cantidad de almuerzos',
          value: paymentProcess.numberLunch.toString(),
          icon: Icons.restaurant_rounded,
        ),
        TicketItem(
          title: 'Total a pagar',
          value: paymentProcess.total.toString(),
          icon: Icons.attach_money,
        ),
        TicketItem(
          title: 'Fecha de expiración',
          value: paymentProcess.expirationDate,
          icon: Icons.date_range,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            paymentProcess.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
              text: 'Continuar',
              onPressed: () {
                //TODO: Launch URL
              }),
        )
      ],
    );
  }
}
