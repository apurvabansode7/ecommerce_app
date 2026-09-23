import 'package:flutter/material.dart';

class Reviews extends StatelessWidget {
  const Reviews({
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(width: 10),

            ...List.generate(5, (index) {
              final filledStars = rating - index;
              final icon = filledStars >= 1
                  ? Icons.star
                  : filledStars >= 0.5
                      ? Icons.star_half
                      : Icons.star_border;
              return Icon(
                icon,
                color: const Color(0xFFFF7622),
                size: 18,
              );
            }),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          '$reviewCount customer reviews',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}