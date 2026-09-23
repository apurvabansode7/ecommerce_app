import 'package:flutter/material.dart';

class CouponInput extends StatelessWidget {
  const CouponInput({
    required this.controller,
    required this.onApply,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter Discount Code',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          TextButton(
            onPressed: onApply,
            child: const Text(
              'Apply',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}