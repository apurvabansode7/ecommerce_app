import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/core/network/api_client.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_header.dart';
import 'package:ecommerce_app/features/products/domain/repositories/shop_repositories.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:ecommerce_app/features/products/presenatation/screens/product_details_screen.dart';
import 'package:ecommerce_app/utlis/responsive.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    required this.category,
    required this.cart,
    required this.favorites,
    super.key,
  });

  final String category;
  final CartBloc cart;
  final FavoritesBloc favorites;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _products = ShopRepository(ApiClient().dio)
        .getProductsByCategory(widget.category);
  }

  Future<void> _refreshProducts() async {
    final request = ShopRepository(ApiClient().dio)
        .getProductsByCategory(widget.category);
    setState(() {
      _products = request;
    });
    await request;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CartHeader(
              title: widget.category.toUpperCase(),
              onBackTap: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _ProductSkeletonList(
                      itemCount: 4,
                      padding: EdgeInsets.fromLTRB(
                        context.wp(5),
                        context.hp(2),
                        context.wp(5),
                        context.hp(3),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return _ProductMessage(
                      message: ApiClient.errorMessage(snapshot.error!),
                      onRetry: () => setState(_loadProducts),
                    );
                  }

                  final products = snapshot.data ?? const <ProductModel>[];
                  if (products.isEmpty) {
                    return const _ProductMessage(
                      message: 'No products found in this category.',
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _refreshProducts,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        context.wp(5),
                        context.hp(2),
                        context.wp(5),
                        context.hp(3),
                      ),
                      itemCount: products.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: context.hp(1.5)),
                      itemBuilder: (context, index) => _ProductCard(
                        product: products[index],
                        cart: widget.cart,
                        favorites: widget.favorites,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.cart,
    required this.favorites,
  });

  final ProductModel product;
   final CartBloc cart;
  final FavoritesBloc favorites;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductDetailsScreen(
                  productId: product.id,
                  cart: cart,
                  favorites: favorites,
                ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: .18)),
          ),
          child: Row(
            children: [
              Container(
                width: 92,
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.contain,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  errorWidget: (_, _, _) =>
                      const Icon(Icons.image_not_supported_outlined),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductSkeletonList extends StatelessWidget {
  const _ProductSkeletonList({required this.itemCount, required this.padding});

  final int itemCount;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: context.hp(1.5)),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 124,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _ProductMessage extends StatelessWidget {
  const _ProductMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
