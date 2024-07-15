import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      this.textColor,
      this.style,
      required this.onPressed,
      this.backgroundColor,
      this.height,
      this.width,
      this.borderRadius,
      this.borderColor,
      this.borderWidth});
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final String text;
  final Color? textColor;
  final TextStyle? style;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              side: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth ?? 0)),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: style ??
                TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    color: textColor ?? Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
