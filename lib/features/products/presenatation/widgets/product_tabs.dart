import 'package:flutter/material.dart';

class ProductTabs extends StatelessWidget {
  const ProductTabs({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      'Description',
      'Specifications',
      'Reviews',
    ];

    return Row(
      children: List.generate(
        tabs.length,
        (index) {
          final selected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selected
                          ? const Color(0xFFFF7622)
                          : Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: selected ? 45 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7622),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}