import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class TicketItem extends StatelessWidget {
  const TicketItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: AppColors.grey,
      title: Text(title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          )),
      subtitle: Text(value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      leading: Icon(icon, color: AppColors.grey),
    );
  }
}
