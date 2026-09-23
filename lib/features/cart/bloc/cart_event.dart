import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/products/model/product.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  const AddToCart(
    this.product, {
    this.quantity = 1,
  });

  final Product product;
  final int quantity;

  @override
  List<Object?> get props => [
        product.id,
        quantity,
      ];
}

class IncrementCartItem extends CartEvent {
  const IncrementCartItem(this.product);

  final Product product;

  @override
  List<Object?> get props => [product.id];
}

class DecrementCartItem extends CartEvent {
  const DecrementCartItem(this.product);

  final Product product;

  @override
  List<Object?> get props => [product.id];
}

class RemoveCartItem extends CartEvent {
  const RemoveCartItem(this.product);

  final Product product;

  @override
  List<Object?> get props => [product.id];
}
