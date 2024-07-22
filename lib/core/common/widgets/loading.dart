import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed)),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryRed),
        )
      ],
    );
  }
}
