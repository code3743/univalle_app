import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class AccumulatedLunches extends StatelessWidget {
  const AccumulatedLunches({
    super.key,
    required this.accumulated,
  });
  final int accumulated;

  get builder => null;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primaryBlue,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Está opción aplica únicamente para las sedes en Cali',
              style: TextStyle(
                  fontSize: 12,
                  height: 1,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
          TweenAnimationBuilder(
              tween: IntTween(
                begin: 0,
                end: accumulated,
              ),
              duration: const Duration(milliseconds: 600),
              builder: (_, value, __) {
                return Text(
                  value.toString(),
                  style: const TextStyle(
                      fontSize: 100,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue),
                );
              }),
          const Text(
            'Almuerzos acumulados',
            style: TextStyle(
                fontSize: 14,
                height: 1,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue),
          ),
        ],
      ),
    );
  }
}
