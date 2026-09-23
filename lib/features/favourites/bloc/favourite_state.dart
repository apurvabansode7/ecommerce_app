import 'package:ecommerce_app/features/products/model/product.dart';
import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.products = const [],
  });

  final List<Product> products;

  bool contains(int id) {
    return products.any((product) => product.id == id);
  }

  @override
  List<Object?> get props => [products];
}
