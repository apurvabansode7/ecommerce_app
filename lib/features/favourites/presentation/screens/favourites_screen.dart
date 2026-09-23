import 'package:ecommerce_app/features/favourites/bloc/favourite_bloc.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_event.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/dashboard/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/utlis/responsive.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({required this.favorites, super.key});

  final FavoritesBloc favorites;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      bloc: favorites,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Favorites',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: state.products.isEmpty
              ? const Center(child: Text('No favorite products yet.'))
              : GridView.builder(
                  padding: EdgeInsets.all(context.wp(5)),
                  itemCount: state.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: context.wp(3),
                    mainAxisSpacing: context.hp(1.5),
                    childAspectRatio: .72,
                  ),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      product: DashboardProduct(
                        name: product.title,
                        price: '\$${product.price.toStringAsFixed(2)}',
                        image: product.image,
                      ),
                      isFavourite: true,
                      onFavouriteChanged: () {
                        favorites.add(ToggleFavorite(product));
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Product removed from favorites'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
