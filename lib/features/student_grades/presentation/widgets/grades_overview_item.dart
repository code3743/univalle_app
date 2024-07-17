import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class GradesOverviewItem extends StatelessWidget {
  const GradesOverviewItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: const TextStyle(
                color: AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        Text(value,
            style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
