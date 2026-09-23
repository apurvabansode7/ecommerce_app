import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/circle_action_button.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({
    required this.product,
    required this.isFavorite,
    required this.onBack,
    required this.onShare,
    required this.onFavorite,
  });

  final ProductModel product;
  final bool isFavorite;

  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.hp(43),
      decoration: const BoxDecoration(
        color: Color(0xFFEDEDED),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.wp(12),
                context.hp(5),
                context.wp(12),
                context.hp(1),
              ),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                  );
                },
              ),
            ),
          ),

          // BACK
          Positioned(
            top: 10,
            left: 16,
            child: CircleActionButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
          ),

          // SHARE
          Positioned(
            top: 10,
            right: 62,
            child: CircleActionButton(
              icon: Icons.share_outlined,
              onTap: onShare,
            ),
          ),

          // FAVORITE
          Positioned(
            top: 10,
            right: 16,
            child: CircleActionButton(
              icon: isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              iconColor: isFavorite
                  ? Colors.red
                  : AppColors.textDark,
              onTap: onFavorite,
            ),
          ),
        ],
      ),
    );
  }
}