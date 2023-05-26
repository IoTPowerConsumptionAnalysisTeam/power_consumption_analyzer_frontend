import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/request_handler.dart';

class PowerSocketCategoryRequestHandler {
  static PowerSocketCategoryRequestHandler get I {
    return GetIt.I<PowerSocketCategoryRequestHandler>();
  }

  Future<http.Response> registerCategory({
    required String userId,
    required String categoryName,
  }) async {
    final response = await RequestHandler.I.post(
      '/user/$userId/category',
      {
        'new_category': categoryName,
      },
    );
    return response;
  }

  Future<http.Response> getAllCategory({
    required String userId,
  }) async {
    final response = await RequestHandler.I.get(
      '/user/$userId/category',
    );
    return response;
  }

  Future<http.Response> getCategory({
    required String userId,
    required String categoryId,
  }) async {
    final response = await RequestHandler.I.get(
      '/user/$userId/category/$categoryId',
    );
    return response;
  }

  Future<http.Response> updateCategory({
    required String userId,
    required String categoryId,
    String? categoryName,
  }) async {
    Map<String, dynamic> body = {};
    if (categoryName != null) {
      body['new_category'] = categoryName;
    }
    final response = await RequestHandler.I.patch(
      '/user/$userId/category/$categoryId',
      body,
    );
    return response;
  }

  Future<http.Response> deleteCategory({
    required String userId,
    required String categoryId,
  }) async {
    final response = await RequestHandler.I.delete(
      '/user/$userId/category/$categoryId',
    );
    return response;
  }

  Future<http.Response> deleteAllCategory({
    required String userId,
  }) async {
    final response = await RequestHandler.I.delete(
      '/user/$userId/category',
    );
    return response;
  }
}
