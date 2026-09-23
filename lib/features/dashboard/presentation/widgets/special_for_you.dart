import 'package:ecommerce_app/features/favourites/bloc/favourite_bloc.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_event.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/products/model/product.dart';

import 'product_card.dart';

class SpecialForYou extends StatelessWidget {
  const SpecialForYou({
    required this.products,
    super.key,
    this.onSeeAll,
    this.onProductTap,
    this.loading = false,
    this.favorites,
    this.onFavouriteChanged,
  });

  final List<ProductModel> products;
  final VoidCallback? onSeeAll;
  final ValueChanged<ProductModel>? onProductTap;
  final bool loading;
  final FavoritesBloc? favorites;
  final ValueChanged<bool>? onFavouriteChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Special For You',
              style: TextStyle(
                fontSize: context.sp(15),
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: context.sp(10),
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: context.hp(1.5)),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loading ? 4 : products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: context.wp(3),
            mainAxisSpacing: context.hp(1.5),
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            if (loading) {
              return ProductCard.skeleton(context);
            }
            final product = products[index];

            return ProductCard(
              product: DashboardProduct(
                name: product.title,
                price: '\$${product.price.toStringAsFixed(2)}',
                image: product.image,
              ),
              onTap: () {
                onProductTap?.call(product);
              },
              isFavourite: favorites?.state.contains(product.id) ?? false,
              onFavouriteChanged: favorites == null
                  ? null
                  : () {
                      final isAdding = !favorites!.state.contains(product.id);
                      favorites!.add(
                        ToggleFavorite(
                          Product(
                            id: product.id,
                            title: product.title,
                            price: product.price,
                            description: product.description,
                            category: product.category,
                            image: product.image,
                          ),
                        ),
                      );
                      onFavouriteChanged?.call(isAdding);
                    },
            );
          },
        ),
      ],
    );
  }
}
