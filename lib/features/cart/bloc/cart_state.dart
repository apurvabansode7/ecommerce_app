import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/products/model/product.dart';

class CartItem extends Equatable {
  const CartItem(
    this.product,
    this.quantity,
  );

  final Product product;
  final int quantity;

  CartItem copyWith({
    int? quantity,
  }) {
    return CartItem(
      product,
      quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        product.id,
        quantity,
      ];
}

class CartState extends Equatable {
  const CartState({
    this.items = const [],
  });

  final List<CartItem> items;

  double get total {
    return items.fold(
      0,
      (sum, item) =>
          sum + (item.product.price * item.quantity),
    );
  }

  @override
  List<Object?> get props => [items];
}
