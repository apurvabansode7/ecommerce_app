import 'package:ecommerce_app/features/products/model/product_model.dart';
import 'package:flutter/material.dart';

class Specifications extends StatelessWidget {
  const Specifications({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SpecificationRow(
          title: 'Category',
          value: product.category,
        ),
        const _SpecificationRow(
          title: 'Material',
          value: 'Premium',
        ),
        const _SpecificationRow(
          title: 'Availability',
          value: 'In Stock',
        ),
      ],
    );
  }
}

class _SpecificationRow extends StatelessWidget {
  const _SpecificationRow({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}