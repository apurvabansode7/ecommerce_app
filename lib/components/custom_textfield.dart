import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.hp(6.2).clamp(48.0, 54.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,

        style: TextStyle(
          fontSize: context.sp(13),
          color: AppColors.textDark,
          fontWeight: FontWeight.w400,
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: TextStyle(
            color: const Color(0xFFBDBDBD),
            fontSize: context.sp(12.5),
            fontWeight: FontWeight.w400,
          ),

          filled: true,
          fillColor: Colors.white,

          suffixIcon: suffix,

          contentPadding: EdgeInsets.symmetric(
            horizontal: context.wp(4),
            vertical: context.hp(1.5),
          ),

          // Remove the visible borders.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1,
            ),
          ),

          errorStyle: TextStyle(
            fontSize: context.sp(10),
          ),
        ),
      ),
    );
  }
}
