import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class TeachingRatingItem extends StatelessWidget {
  const TeachingRatingItem({
    super.key,
    required this.name,
    required this.subject,
    this.onTap,
    required this.isRated,
  });
  final String name;
  final String subject;
  final void Function()? onTap;
  final bool isRated;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            )
          ]),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
              height: 1.1, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subject,
          style: const TextStyle(height: 1.1, fontSize: 12),
        ),
        iconColor: AppColors.primaryBlue,
        textColor: AppColors.grey,
        trailing: isRated
            ? const Icon(Icons.star_rounded)
            : const Icon(Icons.star_border_rounded),
        onTap: onTap,
      ),
    );
  }
}
