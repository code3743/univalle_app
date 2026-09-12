import 'package:flutter/material.dart';

/// Circular avatar that shows a network photo when one is available,
/// falling back to an initials badge while it loads, on error, or when no
/// photo URL is given at all — the photo is always optional.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.radius,
    required this.initials,
    this.photoUrl,
    this.backgroundColor,
    this.textStyle,
  });

  final double radius;
  final String initials;
  final String? photoUrl;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  Widget _initialsAvatar(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(initials, style: textStyle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = this.photoUrl;
    if (photoUrl == null) return _initialsAvatar(context);

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (context, error, stackTrace) =>
              _initialsAvatar(context),
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : _initialsAvatar(context),
        ),
      ),
    );
  }
}
