import 'package:ecommerce_app/features/products/model/product.dart';
import 'package:equatable/equatable.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class ToggleFavorite extends FavoritesEvent {
  const ToggleFavorite(this.product);

  final Product product;

  @override
  List<Object?> get props => [product.id];
}
