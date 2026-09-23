import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key, this.onBackTap, this.title = 'My Cart'});

  final VoidCallback? onBackTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(5)),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBackTap,
          ),

          const Spacer(),

          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const Spacer(),

          // This keeps "My Cart" perfectly centered.
          SizedBox(width: context.wp(10), height: context.wp(10)),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

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
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: context.sp(18), color: AppColors.textDark),
      ),
    );
  }
}
