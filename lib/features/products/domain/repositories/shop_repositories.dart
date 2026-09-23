import 'package:dio/dio.dart';
import 'package:ecommerce_app/constants/api_constants.dart';
import 'package:ecommerce_app/features/products/model/product_model.dart';

class ShopRepository {
  ShopRepository(this._dio);

  final Dio _dio;

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categories);

      print('Categories status: ${response.statusCode}');
      print('Categories data: ${response.data}');

      return List<String>.from(response.data);
    } on DioException catch (e) {
      print('Categories API ERROR');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Status: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(
    String category,
  ) async {
    try {
      final url = ApiConstants.byCategory(category);

      print('Products URL: ${_dio.options.baseUrl}$url');

      final response = await _dio.get(url);

      print('Products status: ${response.statusCode}');
      print('Products data: ${response.data}');

      return (response.data as List)
          .map(
            (e) => ProductModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } on DioException catch (e) {
      print('Products API ERROR');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Status: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');
      rethrow;
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get(
        ApiConstants.productById(id),
      );

      print('Product status: ${response.statusCode}');
      print('Product data: ${response.data}');

      return ProductModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      print('Product API ERROR');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('URL: ${e.requestOptions.uri}');
      print('Status: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');
      rethrow;
    }
  }
}