import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:ecommerce_app/features/dashboard/presentation/screeens/dashboard_screen.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_bloc.dart';
import 'package:ecommerce_app/features/favourites/presentation/screens/favourites_screen.dart';
import 'package:ecommerce_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;
  final CartBloc _cart = CartBloc();
  final FavoritesBloc _favorites = FavoritesBloc();

  late final List<Widget> _screens = [
    DashboardScreen(cart: _cart, favorites: _favorites),
    CartScreen(cart: _cart),
    FavouritesScreen(favorites: _favorites),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _cart.close();
    _favorites.close();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.wp(5),
            vertical: context.hp(1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
              ),

              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
              ),

              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
              ),

              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: context.wp(15),
        height: context.hp(5.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Icon(
                isSelected ? activeIcon : icon,
                size: context.sp(24),
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
            ),

            SizedBox(height: context.hp(0.5)),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: isSelected ? context.wp(1.5) : 0,
              height: isSelected ? context.wp(1.5) : 0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
