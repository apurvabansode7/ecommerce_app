import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/product_tabs.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/rating_row.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/reviews.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/specification.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class ProductInformation extends StatelessWidget {
  const ProductInformation({
    required this.product,
    required this.colors,
    required this.selectedColor,
    required this.selectedTab,
    required this.onColorSelected,
    required this.onTabSelected,
  });

  final ProductModel product;

  final List<Color> colors;
  final int selectedColor;
  final int selectedTab;

  final ValueChanged<int> onColorSelected;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(
        0,
        -22,
        0,
      ),
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.sp(17),
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          // PRICE + SELLER
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              const Text(
                'Seller: ',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              Text(
                'Syed Noman',
                style: TextStyle(
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // RATING
          RatingRow(
            rating: product.rating,
            reviewCount: product.ratingCount,
          ),

          const SizedBox(height: 14),

          // COLOR
          const Text(
            'Color',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: List.generate(
              colors.length,
              (index) {
                return GestureDetector(
                  onTap: () => onColorSelected(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == index
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // TABS
          ProductTabs(
            selectedIndex: selectedTab,
            onSelected: onTabSelected,
          ),

          const SizedBox(height: 14),

          // TAB CONTENT
          _buildTabContent(context),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (selectedTab) {
      case 1:
        return Specifications(product: product);

      case 2:
        return Reviews(
          rating: product.rating,
          reviewCount: product.ratingCount,
        );

      default:
        return Text(
          product.description,
          style: TextStyle(
            fontSize: context.sp(11),
            color: Colors.grey.shade700,
            height: 1.55,
          ),
        );
    }
  }
}