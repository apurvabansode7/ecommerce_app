import 'package:flutter/material.dart';

extension Responsive on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);

  double get screenW => _size.width;
  double get screenH => _size.height;

  /// width percentage: context.wp(5) = 5% of screen width
  double wp(double percent) => _size.width * percent / 100;

  /// height percentage
  double hp(double percent) => _size.height * percent / 100;

  /// scalable font/icon size (base design width = 375)
  double sp(double size) => size * (_size.width / 375).clamp(0.85, 1.3);

  bool get isTablet => _size.width >= 600;

  /// grid columns adapt to screen width
  int get gridColumns => _size.width >= 900 ? 4 : (_size.width >= 600 ? 3 : 2);
}