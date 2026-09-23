import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardProduct {
  final String name;
  final String price;
  final String image;
  final List<Color> colors;

  const DashboardProduct({
    required this.name,
    required this.price,
    required this.image,
    this.colors = const [],
  });
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isFavourite = false,
    this.onFavouriteChanged,
  });

  final DashboardProduct product;
  final VoidCallback? onTap;
  final bool isFavourite;
  final VoidCallback? onFavouriteChanged;

  static Widget skeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  void _toggleFavourite() {
    widget.onFavouriteChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // =====================================================
            // PRODUCT CONTENT
            // =====================================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------
                // PRODUCT IMAGE
                // -------------------------------------------------
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: context.wp(1.5),
                      right: context.wp(1.5),
                      top: context.wp(1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        //color: const Color(0xFFEDEDED),
                        child: widget.product.image.startsWith('http')
                            ? Image.network(
                                widget.product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Icon(
                                  Icons.image_not_supported_outlined,
                                ),
                              )
                            : Image.asset(
                                widget.product.image,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),

                // -------------------------------------------------
                // PRODUCT INFORMATION
                // -------------------------------------------------
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.wp(2),
                    context.hp(0.4),
                    context.wp(2),
                    context.hp(1.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.sp(9.5),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                          height: 1.1,
                        ),
                      ),

                      SizedBox(height: context.hp(0.35)),

                      // Price + colors
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.product.price,
                            style: TextStyle(
                              fontSize: context.sp(9.5),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),

                          const Spacer(),

                          _ColorDots(colors: widget.product.colors),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // =====================================================
            // FAVOURITE BUTTON
            // =====================================================
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: _toggleFavourite,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: context.wp(7.5),
                  height: context.wp(7.5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Icon(
                    widget.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                    size: context.sp(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// COLOR DOTS
// =============================================================

class _ColorDots extends StatelessWidget {
  const _ColorDots({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors.take(5).map((color) {
        return Container(
          margin: EdgeInsets.only(left: context.wp(0.8)),
          width: context.wp(2.4),
          height: context.wp(2.4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }).toList(),
    );
  }
}
