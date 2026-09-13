import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../home_strings.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.onNotifications,
    required this.onAvatarTap,
    required this.initial,
    this.photoUrl,
  });

  final VoidCallback onNotifications;
  final VoidCallback onAvatarTap;
  final String initial;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const AppLogo(size: 36),
        SizedBox(width: AppSpacing.sm),
        Text(
          HomeStrings.universityName,
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold, height: 1),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          tooltip: HomeStrings.notifications,
          onPressed: onNotifications,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onAvatarTap,
          child: UserAvatar(
            radius: 18,
            initials: initial,
            photoUrl: photoUrl,
            backgroundColor: colorScheme.surfaceContainerHighest,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
