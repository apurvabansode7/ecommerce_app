import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/network/api_client.dart';
import 'package:ecommerce_app/features/dashboard/bloc/dashboard_event.dart';
import 'package:ecommerce_app/features/dashboard/bloc/dashboard_state.dart';
import 'package:ecommerce_app/features/products/domain/repositories/shop_repositories.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._repository) : super(const DashboardState()) {
    on<LoadCategories>(_loadCategories);
    on<LoadProductsByCategory>(_loadProducts);
  }

  final ShopRepository _repository;

  Future<void> _loadCategories(
    LoadCategories event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading, errorMessage: null));
    try {
      final categories = await _repository.getCategories();
      emit(
        state.copyWith(
          categories: categories,
          status: DashboardStatus.success,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: ApiClient.errorMessage(error),
        ),
      );
    }
  }

  Future<void> _loadProducts(
    LoadProductsByCategory event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading, errorMessage: null));
    try {
      final products = await _repository.getProductsByCategory(event.category);
      emit(
        state.copyWith(
          products: products,
          status: DashboardStatus.success,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: ApiClient.errorMessage(error),
        ),
      );
    }
  }
}
