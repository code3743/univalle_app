import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/themes/app_colors.dart';
import 'package:univalle_app/core/providers/profile_picture_provider.dart';

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({
    super.key,
    this.isEditable = false,
    this.imageUrl,
  });

  final bool isEditable;
  final String? imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(profilePictureProvider);

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
                  image: file != null
                      ? DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        )
                      : null,
                  border: Border.all(
                    color: AppColors.white,
                    width: 3,
                  ),
                ),
                child: file == null
                    ? const Icon(
                        Icons.person,
                        size: 80,
                        color: AppColors.white,
                      )
                    : null),
          ),
          if (isEditable)
            Positioned(
              left: 105,
              bottom: 15,
              child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () async => await ref
                      .read(profilePictureProvider.notifier)
                      .pickImage(),
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
