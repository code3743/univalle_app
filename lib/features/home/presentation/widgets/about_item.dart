import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class AboutItem extends StatelessWidget {
  const AboutItem({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });
  final String title;
  final String value;
  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    icon,
                    fit: BoxFit.contain,
                  ),
                ),
              )),
          Text(title,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )),
          Container(
            width: double.infinity,
            height: 27,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(value,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
