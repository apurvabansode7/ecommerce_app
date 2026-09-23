import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
  });

  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderIconButton(
          icon: Icons.grid_view_rounded,
          onTap: onMenuTap,
        ),

        const Spacer(),

        _HeaderIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: context.wp(10),
        height: context.wp(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: context.sp(20),
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
