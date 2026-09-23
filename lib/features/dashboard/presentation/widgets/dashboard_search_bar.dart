import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({
    super.key,
    this.controller,
    this.onFilterTap,
    this.onChanged,
  });

  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.hp(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(width: context.wp(4)),

          Icon(
            Icons.search_rounded,
            size: context.sp(22),
            color: AppColors.textDark,
          ),

          SizedBox(width: context.wp(2)),

          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: context.sp(12),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          Container(
            width: 1,
            height: context.hp(2.5),
            color: Colors.grey.shade300,
          ),

          IconButton(
            onPressed: onFilterTap,
            icon: Icon(
              Icons.tune_rounded,
              size: context.sp(19),
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
