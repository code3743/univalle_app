import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/features/restaurant/domain/entities/student_restaurant.dart';
import 'package:univalle_app/features/restaurant/presentation/widgets/widgets.dart';

class TicketInformation extends StatelessWidget {
  const TicketInformation({
    super.key,
    required this.studentRestaurant,
  });
  final StudentRestaurant studentRestaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccumulatedLunches(accumulated: studentRestaurant.numberLunch),
        const SizedBox(height: 10),
        TicketItem(
            title: 'Tipo de vinculación',
            value: studentRestaurant.typeLink,
            icon: Icons.person),
        TicketItem(
          title: 'Valor del almuerzo',
          value: studentRestaurant.priceLunch.toString(),
          icon: Icons.restaurant_rounded,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            color: AppColors.grey,
            thickness: 1,
          ),
        ),
        studentRestaurant.paymentProcess == null
            ? BuyLunchs(
                minLunches: studentRestaurant.minNumberLunch,
                maxLunches: studentRestaurant.maxNumberLunch,
                lunchPrice: studentRestaurant.priceLunch,
              )
            : ContinuePayment(
                paymentProcess: studentRestaurant.paymentProcess!),
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
    );
  }
}
