import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CircleActionButton extends StatelessWidget {
  const CircleActionButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 19,
            color: iconColor ?? AppColors.textDark,
          ),
        ),
      ),
    );
  }
}