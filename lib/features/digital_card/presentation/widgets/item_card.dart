import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(color: AppColors.black, height: 1, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
              color: AppColors.black,
              height: 1,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
