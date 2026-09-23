class ApiConstants {
  static const baseUrl = 'https://fakestoreapi.com';
  static const categories = '/products/categories';
  static String byCategory(String c) =>
      '/products/category/${Uri.encodeComponent(c)}';
  static String productById(int id) => '/products/$id';
}