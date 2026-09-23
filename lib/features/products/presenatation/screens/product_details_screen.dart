import 'package:ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/cart/bloc/cart_event.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_bloc.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_event.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_state.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/bottom_action_bar.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/product_image_selection.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/product_info.dart';
import 'package:ecommerce_app/features/products/model/product.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    required this.productId,
    required this.cart,
    required this.favorites,
    super.key,
  });

  final int productId;
  final CartBloc cart;
  final FavoritesBloc favorites;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Future<ProductModel> _product = ApiService().fetchProduct(
    widget.productId,
  );

  int _selectedColor = 0;
  int _quantity = 1;
  int _selectedTab = 0;
  /*
   * Your API currently appears to provide only one image.
   *
   * When you have real color variants, replace this with:
   *
   * List<String> _colorImages = [
   *   product.image,
   *   product.blackImage,
   *   product.blueImage,
   *   ...
   * ];
   *
   * For now the selected color UI works, while the same API
   * image is used until variant images are available.
   */

  final List<Color> _colors = [
    const Color(0xFF3F4245),
    const Color(0xFFF5EDE2),
    const Color(0xFFFF8A3D),
    const Color(0xFF6B9AC4),
    const Color(0xFF8B9195),
  ];

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity <= 1) {
      return;
    }

    setState(() {
      _quantity--;
    });
  }

  void _addToCart(ProductModel product) {
    widget.cart.add(
      AddToCart(
        Product(
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.image,
        ),
        quantity: _quantity,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _quantity == 1
                      ? 'Product added to cart'
                      : '$_quantity products added to cart',
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _shareProduct(ProductModel product) {
    /*
     * If you want native Android/iOS sharing:
     *
     * add share_plus to pubspec.yaml
     * and use Share.share(...)
     *
     * For now this keeps the screen dependency-free.
     */
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Share product')));
  }

  void _selectColor(int index) {
    setState(() {
      _selectedColor = index;
    });

    /*
     * When variant images are available:
     *
     * setState(() {
     *   _selectedImage = colorImages[index];
     * });
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: FutureBuilder<ProductModel>(
        future: _product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load product.\n${snapshot.error ?? ''}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final product = snapshot.data!;

          return BlocBuilder<FavoritesBloc, FavoritesState>(
            bloc: widget.favorites,
            builder: (context, state) => _buildContent(context, product, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductModel product,
    FavoritesState favoritesState,
  ) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ProductImageSection(
                  product: product,
                  isFavorite: favoritesState.contains(product.id),
                  onBack: () {
                    Navigator.pop(context);
                  },
                  onShare: () {
                    _shareProduct(product);
                  },
                  onFavorite: () {
                    final isAdding = !favoritesState.contains(product.id);
                    widget.favorites.add(
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
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            isAdding
                                ? 'Product added to favorites'
                                : 'Product removed from favorites',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: ProductInformation(
                  product: product,
                  colors: _colors,
                  selectedColor: _selectedColor,
                  selectedTab: _selectedTab,
                  onColorSelected: _selectColor,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
              ),

              // Space for bottom action bar.
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomActionBar(
              quantity: _quantity,
              onDecrease: _decreaseQuantity,
              onIncrease: _increaseQuantity,
              onAddToCart: () {
                _addToCart(product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
