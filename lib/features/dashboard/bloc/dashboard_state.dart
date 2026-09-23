import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.categories = const [],
    this.products = const [],
    this.status = DashboardStatus.initial,
    this.errorMessage,
  });

  final List<String> categories;
  final List<ProductModel> products;
  final DashboardStatus status;
  final String? errorMessage;

  DashboardState copyWith({
    List<String>? categories,
    List<ProductModel>? products,
    DashboardStatus? status,
    String? errorMessage,
  }) {
    return DashboardState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, products, status, errorMessage];
}
