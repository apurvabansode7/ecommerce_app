import 'dart:convert';

import 'package:ecommerce_app/features/products/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<LoadCart>(_load);
    on<AddToCart>(_add);
    on<IncrementCartItem>(_increment);
    on<DecrementCartItem>(_decrement);
    on<RemoveCartItem>(_remove);

    add(const LoadCart());
  }

  static const String _storageKey = 'cart_items';

  Future<void> _load(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    final rawItems =
        preferences.getStringList(_storageKey) ?? [];

    final items = <CartItem>[];

    for (final rawItem in rawItems) {
      try {
        final json =
            jsonDecode(rawItem) as Map<String, dynamic>;

        final product = Product.fromJson(
          json['product'] as Map<String, dynamic>,
        );

        final quantity =
            (json['quantity'] as num).toInt();

        items.add(
          CartItem(
            product,
            quantity,
          ),
        );
      } on FormatException {
        // Ignore malformed data.
      } on TypeError {
        // Ignore incompatible data.
      }
    }

    emit(
      CartState(
        items: items,
      ),
    );
  }

  Future<void> _persist(CartState state) async {
    final preferences =
        await SharedPreferences.getInstance();

    final values = state.items.map((item) {
      return jsonEncode({
        'product': item.product.toJson(),
        'quantity': item.quantity,
      });
    }).toList();

    await preferences.setStringList(
      _storageKey,
      values,
    );
  }

  Future<void> _add(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    final items = [...state.items];

    final index = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (index == -1) {
      items.add(
        CartItem(
          event.product,
          event.quantity,
        ),
      );
    } else {
      final item = items[index];

      items[index] = item.copyWith(
        quantity: item.quantity + event.quantity,
      );
    }

    final nextState = CartState(
      items: items,
    );

    emit(nextState);

    await _persist(nextState);
  }

  Future<void> _increment(
    IncrementCartItem event,
    Emitter<CartState> emit,
  ) async {
    await _add(
      AddToCart(event.product),
      emit,
    );
  }

  Future<void> _decrement(
    DecrementCartItem event,
    Emitter<CartState> emit,
  ) async {
    final items = [...state.items];

    final index = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (index == -1) return;

    final item = items[index];

    if (item.quantity == 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(
        quantity: item.quantity - 1,
      );
    }

    final nextState = CartState(
      items: items,
    );

    emit(nextState);

    await _persist(nextState);
  }

  Future<void> _remove(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final items = state.items
        .where(
          (item) => item.product.id != event.product.id,
        )
        .toList();

    final nextState = CartState(
      items: items,
    );

    emit(nextState);

    await _persist(nextState);
  }
}
