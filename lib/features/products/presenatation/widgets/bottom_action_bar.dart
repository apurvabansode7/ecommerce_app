import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/products/presenatation/widgets/quantity_stepper.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAddToCart,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          14,
          0,
          14,
          10,
        ),
        child: Container(
          height: 65,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
             // color: Colors.white,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ---------------------------------------------
              // QUANTITY
              // ---------------------------------------------
              QuantityStepper(
                quantity: quantity,
                onDecrease: onDecrease,
                onIncrease: onIncrease,
              ),

              const SizedBox(width: 8),

              // ---------------------------------------------
              // ADD TO CART
              // ---------------------------------------------
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7622),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}