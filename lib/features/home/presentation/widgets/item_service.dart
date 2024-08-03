import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class ItemService extends StatelessWidget {
  const ItemService({
    super.key,
    required this.title,
    this.onTap,
    required this.icon,
    this.primaryColor,
  });
  final String title;
  final void Function()? onTap;
  final String icon;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 70,
                width: 70,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: primaryColor?.withOpacity(0.07) ??
                            AppColors.primaryRed.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          icon,
                          colorFilter: ColorFilter.mode(
                            primaryColor ?? AppColors.primaryBlue,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor?.withOpacity(0.07) ??
                    AppColors.primaryRed.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
