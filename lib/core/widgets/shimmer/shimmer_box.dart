import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, this.width, this.height, this.radius = 12})
    : _isCircle = false;

  const ShimmerBox.circle(double size, {super.key})
    : width = size,
      height = size,
      radius = size / 2,
      _isCircle = true;

  final double? width;
  final double? height;
  final double radius;
  final bool _isCircle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        shape: _isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: _isCircle ? null : BorderRadius.circular(radius),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}
