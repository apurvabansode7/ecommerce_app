import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItem {
  final String title;
  final IconData icon;

  const CategoryItem({required this.title, required this.icon});
}

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.categories,
    this.loading = false,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<String>? categories;
  final bool loading;

  static const List<CategoryItem> defaultCategories = [
    CategoryItem(title: 'All', icon: Icons.grid_view_rounded),
    CategoryItem(title: 'Shoes', icon: Icons.directions_run_rounded),
    CategoryItem(title: "Men's", icon: Icons.checkroom_outlined),
    CategoryItem(title: 'Watches', icon: Icons.watch_outlined),
    CategoryItem(title: 'Electronics', icon: Icons.headphones_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: context.hp(10),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, _) => SizedBox(width: context.wp(3)),
          itemBuilder: (_, _) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Column(
              children: [
                Container(
                  width: context.wp(13),
                  height: context.wp(13),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: context.hp(.7)),
                Container(
                  width: context.wp(12),
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final items = categories == null
        ? defaultCategories
        : categories!
              .map(
                (category) =>
                    CategoryItem(title: category, icon: _iconFor(category)),
              )
              .toList();

    return SizedBox(
      height: context.hp(10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) {
          return SizedBox(width: context.wp(3));
        },
        itemBuilder: (context, index) {
          final category = items[index];
          final selected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(index),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: context.wp(15),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: context.wp(13),
                    height: context.wp(13),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : const Color(0xFFF1F1F1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      category.icon,
                      color: selected
                          ? AppColors.textDark
                          : Colors.grey.shade600,
                      size: context.sp(22),
                    ),
                  ),

                  SizedBox(height: context.hp(0.5)),

                  Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? AppColors.primary : AppColors.textDark,
                      fontSize: context.sp(9),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static IconData _iconFor(String category) {
    if (category.contains('electronics')) return Icons.headphones_outlined;
    if (category.contains('jewel')) return Icons.diamond_outlined;
    if (category.contains('women')) return Icons.shopping_bag_outlined;
    return Icons.checkroom_outlined;
  }
}
