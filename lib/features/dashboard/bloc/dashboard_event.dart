
import 'package:equatable/equatable.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends DashboardEvent {
  const LoadCategories();
}

class LoadProductsByCategory extends DashboardEvent {
  const LoadProductsByCategory(this.category);

  final String category;

  @override
  List<Object?> get props => [category];
}
