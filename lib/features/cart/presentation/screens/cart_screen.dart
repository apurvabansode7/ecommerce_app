import 'package:ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/cart/bloc/cart_event.dart';
import 'package:ecommerce_app/features/cart/bloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/cart/data/model/cart_model.dart'
    as cart_model;
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_header.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({required this.cart, super.key});

 final CartBloc cart;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      bloc: widget.cart,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8F8F8),
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: CartHeader(
              onBackTap: () {
                final navigator = Navigator.of(context);
                if (navigator.canPop()) {
                  navigator.pop();
                }
              },
            ),
          ),
        
        body: SafeArea(
  child: Stack(
    children: [
      // ------------------------------------------------
      // CART ITEMS / EMPTY CART
      // ------------------------------------------------
      state.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Add some products to your cart.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                240, // space for bottom summary
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                final product = item.product;

                return CartItemCard(
                  item: cart_model.CartItem(
                    id: '${product.id}',
                    name: product.title,
                    category: product.category,
                    imageUrl: product.image,
                    price: product.price,
                    quantity: item.quantity,
                  ),

                  // +
                  onIncrement: () {
                    widget.cart.add(
                      IncrementCartItem(product),
                    );
                  },

                  // -
                  onDecrement: () {
                    widget.cart.add(
                      DecrementCartItem(product),
                    );
                  },

                  // Remove
                  onRemove: () {
                    widget.cart.add(
                      RemoveCartItem(product),
                    );
                  },
                );
              },
            ),

      // ------------------------------------------------
      // BOTTOM SUMMARY
      // ONLY SHOW WHEN CART HAS ITEMS
      // ------------------------------------------------
      if (state.items.isNotEmpty)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CartSummaryBottomSheet(
            subtotal: state.total,
            total: state.total,
            couponController: _couponController,

            onApplyCoupon: () {
              debugPrint(
                'Coupon: ${_couponController.text}',
              );
            },

            onCheckout: () {
              debugPrint('Checkout pressed');
            },
          ),
        ),
    ],
  ),
),
        );
      },
    );
  }
}
