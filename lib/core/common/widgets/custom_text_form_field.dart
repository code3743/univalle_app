import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.width,
      this.prefixIcon,
      this.hintText,
      this.height,
      this.controller,
      this.obscureText = false,
      this.validator,
      this.enabled = true,
      this.textAlign,
      this.initialValue,
      this.suffixIcon,
      this.keyboardType});
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final String? initialValue;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        textAlign: textAlign ?? TextAlign.start,
        initialValue: initialValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabled: enabled,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
        ),
      ),
    );
  }
}
