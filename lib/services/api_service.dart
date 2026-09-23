import 'package:ecommerce_app/core/network/api_client.dart';
import 'package:ecommerce_app/features/products/domain/repositories/shop_repositories.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';

class ApiService {
  ApiService() : _repository = ShopRepository(ApiClient().dio);

  final ShopRepository _repository;

  Future<List<String>> fetchCategories() async {
    return _repository.getCategories();
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    return _repository.getProductsByCategory(category);
  }

  Future<ProductModel> fetchProduct(int id) async {
    return _repository.getProductById(id);
  }
}
