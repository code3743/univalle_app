import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:univalle_app/core/utils/svg_paths.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.padding,
    this.size = 35,
    this.isHero = true,
  });

  final EdgeInsetsGeometry? padding;
  final double size;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: isHero
          ? Hero(
              tag: 'app_logo',
              child: SizedBox(
                  height: size,
                  width: size,
                  child: SvgPicture.asset(SvgPaths.logo)),
            )
          : SizedBox(
              height: size,
              width: size,
              child: SvgPicture.asset(SvgPaths.logo)),
    );
  }
}
