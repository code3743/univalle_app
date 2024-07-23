import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    this.isEditable = false,
    this.imageUrl,
  });

  final bool isEditable;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'profile_picture',
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue,
                border: Border.all(
                  color: AppColors.white,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 80,
                color: AppColors.white,
              ),
            ),
          ),
          if (isEditable)
            Positioned(
              left: 105,
              bottom: 15,
              child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primaryRed,
                  )),
            )
        ],
      ),
    );
  }
}
