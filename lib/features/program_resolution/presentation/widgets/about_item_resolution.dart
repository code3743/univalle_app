import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class AboutItemResolution extends StatelessWidget {
  const AboutItemResolution({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(seconds: 2),
            builder: (_, value, __) {
              return Text(
                value.toString(),
                style: const TextStyle(
                    fontSize: 40,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold),
              );
            }),
        Text(
          title,
          style: const TextStyle(fontSize: 14, height: 1),
        ),
      ],
    );
  }
}
