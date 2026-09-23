import 'dart:convert';

import 'package:ecommerce_app/features/favourites/bloc/favourite_event.dart';
import 'package:ecommerce_app/features/favourites/bloc/favourite_state.dart';
import 'package:ecommerce_app/features/products/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<LoadFavorites>(_load);
    on<ToggleFavorite>(_toggle);

    add(const LoadFavorites());
  }

  static const String _storageKey = 'favorite_products';

  Future<void> _load(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    final values = preferences.getStringList(_storageKey) ?? [];

    final products = <Product>[];

    for (final value in values) {
      try {
        products.add(
          Product.fromJson(
            jsonDecode(value) as Map<String, dynamic>,
          ),
        );
      } catch (_) {
        // Ignore invalid saved favorite.
      }
    }

    emit(FavoritesState(products: products));
  }

  Future<void> _toggle(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final products = [...state.products];

    final index = products.indexWhere(
      (product) => product.id == event.product.id,
    );

    if (index == -1) {
      products.add(event.product);
    } else {
      products.removeAt(index);
    }

    emit(FavoritesState(products: products));

    final preferences = await SharedPreferences.getInstance();

    await preferences.setStringList(
      _storageKey,
      products.map((product) {
        return jsonEncode(product.toJson());
      }).toList(),
    );
  }
}
