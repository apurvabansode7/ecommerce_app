import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';

class CartSummaryBottomSheet extends StatelessWidget {
  const CartSummaryBottomSheet({
    required this.subtotal,
    required this.total,
    required this.couponController,
    required this.onApplyCoupon,
    required this.onCheckout,
    super.key,
  });

  final double subtotal;
  final double total;

  final TextEditingController couponController;

  final VoidCallback onApplyCoupon;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          context.wp(4),
          context.hp(1.5),
          context.wp(4),
          context.hp(1.5),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ------------------------------------------
              // DISCOUNT CODE
              // ------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: context.hp(5.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter Discount Code',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: context.sp(10),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: context.wp(2)),

                  TextButton(
                    onPressed: onApplyCoupon,
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: context.sp(10),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.hp(1.5)),

              // ------------------------------------------
              // SUBTOTAL
              // ------------------------------------------
              Row(
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: context.sp(10),
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.hp(1)),

              // ------------------------------------------
              // TOTAL
              // ------------------------------------------
              Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: context.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.hp(1.5)),

              // ------------------------------------------
              // CHECKOUT
              // ------------------------------------------
              SizedBox(
                width: double.infinity,
                height: context.hp(6),
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.bold,
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