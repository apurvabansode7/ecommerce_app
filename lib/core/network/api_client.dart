import 'package:dio/dio.dart';
import 'package:ecommerce_app/constants/api_constants.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Flutter App)',
        },
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
  }

  static String errorMessage(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return 'Server error (${e.response?.statusCode ?? 'unknown'}).';
      }
    }
    return 'Something went wrong.';
  }
}