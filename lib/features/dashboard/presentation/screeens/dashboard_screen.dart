import 'package:ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/dashboard/presentation/widgets/category_selector.dart';
import 'package:ecommerce_app/features/dashboard/presentation/widgets/dashboard_header.dart'
    show DashboardHeader;
import 'package:ecommerce_app/features/dashboard/presentation/widgets/dashboard_search_bar.dart';
import 'package:ecommerce_app/features/dashboard/presentation/widgets/sale_banner.dart';
import 'package:ecommerce_app/features/dashboard/presentation/widgets/special_for_you.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_bloc.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_state.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:ecommerce_app/features/products/presenatation/screens/product_details_screen.dart';
import 'package:ecommerce_app/features/products/presenatation/screens/product_list_screen.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    required this.cart,
    required this.favorites,
    super.key,
  });

   final CartBloc cart;
  final FavoritesBloc favorites;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  Future<List<String>> _categories = Future.value(const <String>[]);
  Future<List<ProductModel>>? _products;
  int _selectedCategory = 0;
  String? _selectedCategoryName;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final categories = await _api.fetchCategories();

      if (!mounted) return;

      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategory = 0;
          _selectedCategoryName = categories.first;
          _categories = Future.value(categories);
          _products = _api.fetchProductsByCategory(categories.first);
        });
      } else {
        setState(() {
          _categories = Future.value(categories);
          _products = null;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _categories = Future.error(e);
        _products = null;
      });
    }
  }

  void _onCategorySelected(int index, List<String> categories) {
    setState(() {
      _selectedCategory = index;
      _selectedCategoryName = categories[index];
      _products = _api.fetchProductsByCategory(categories[index]);
    });
  }

  Future<void> _refreshDashboard() async {
    final categoriesFuture = _api.fetchCategories();
    final productsFuture = _selectedCategoryName == null
        ? null
        : _api.fetchProductsByCategory(_selectedCategoryName!);
    setState(() {
      _categories = categoriesFuture;
      _products = productsFuture;
    });
    await categoriesFuture;
    if (productsFuture != null) {
      await productsFuture;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      bloc: widget.favorites,
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: DashboardHeader(),
        ),
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: Colors.orange,
            onRefresh: _refreshDashboard,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: EdgeInsets.fromLTRB(
                //       context.wp(5),
                //       context.hp(1),
                //       context.wp(5),
                //       0,
                //     ),
                //     child: DashboardHeader(
                //       onMenuTap: () {},
                //       onNotificationTap: () {},
                //     ),
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.wp(5),
                      context.hp(1.2),
                      context.wp(5),
                      0,
                    ),
                    child: DashboardSearchBar(
                      controller: _searchController,
                      onFilterTap: () {},
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.wp(5),
                      context.hp(2),
                      context.wp(5),
                      0,
                    ),
                    child: FutureBuilder<List<String>>(
                      future: _categories,
                      builder: (context, snapshot) => SaleBanner(
                        loading:
                            snapshot.connectionState == ConnectionState.waiting,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.hp(2),
                      left: context.wp(5),
                    ),
                    child: FutureBuilder<List<String>>(
                      future: _categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CategorySelector(
                            loading: true,
                            selectedIndex: 0,
                            onSelected: _ignoreCategorySelection,
                          );
                        }
                        if (snapshot.hasError) {
                          return _ApiMessage(
                            message: 'Unable to load categories.',
                            onRetry: () => setState(_loadInitialData),
                          );
                        }
                        final categories = snapshot.data ?? const <String>[];
                        if (categories.isEmpty) {
                          return const _ApiMessage(
                            message: 'No categories available.',
                          );
                        }
                        return CategorySelector(
                          categories: categories,
                          selectedIndex: _selectedCategory,
                          onSelected: (index) =>
                              _onCategorySelected(index, categories),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.wp(5),
                      context.hp(1.5),
                      context.wp(5),
                      context.hp(3),
                    ),
                    child: _SpecialProducts(
                      productsFuture: _products,
                      cart: widget.cart,
                      category: _selectedCategoryName,
                      favorites: widget.favorites,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _ignoreCategorySelection(int index) {}
}

class _SpecialProducts extends StatelessWidget {
  const _SpecialProducts({
    required this.productsFuture,
    required this.cart,
    required this.category,
    required this.favorites,
  });

  final Future<List<ProductModel>>? productsFuture;
  final CartBloc cart;
  final String? category;
  final FavoritesBloc favorites;

  @override
  Widget build(BuildContext context) {
    if (productsFuture == null) {
      return const SpecialForYou(products: [], loading: true);
    }

    return FutureBuilder<List<ProductModel>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpecialForYou(products: [], loading: true);
        }
        if (snapshot.hasError) {
          return const _ApiMessage(message: 'Unable to load products.');
        }
        final products = snapshot.data ?? const <ProductModel>[];
        if (products.isEmpty) {
          return const _ApiMessage(message: 'No products found.');
        }
        return SpecialForYou(
          products: products,
          favorites: favorites,
          onFavouriteChanged: (isAdding) {
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
          onProductTap: (product) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(
                  productId: product.id,
                  cart: cart,
                  favorites: favorites,
                ),
              ),
            );
          },
          onSeeAll: category == null
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(
                      category: category!,
                      cart: cart,
                      favorites: favorites,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _ApiMessage extends StatelessWidget {
  const _ApiMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
