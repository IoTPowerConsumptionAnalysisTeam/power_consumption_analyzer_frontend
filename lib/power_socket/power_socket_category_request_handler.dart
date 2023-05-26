import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_manager.dart';
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
    PowerSocketCategoryManager.I.fetchAllCategory();
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
    required String originalCategoryName,
    required String newCategoryName,
  }) async {
    Map<String, dynamic> body = {};
    body['origin_name'] = originalCategoryName;
    body['new_name'] = newCategoryName;
    final response = await RequestHandler.I.patch(
      '/user/$userId/category',
      body,
    );
    PowerSocketCategoryManager.I.fetchAllCategory();
    return response;
  }

  Future<http.Response> deleteCategory(
      {required String userId, required String categoryName}) async {
    final response = await RequestHandler.I.delete(
      '/user/$userId/category/$categoryName',
    );
    PowerSocketCategoryManager.I.fetchAllCategory();
    return response;
  }

  Future<http.Response> deleteAllCategory({
    required String userId,
  }) async {
    final response = await RequestHandler.I.delete(
      '/user/$userId/category',
    );
    PowerSocketCategoryManager.I.fetchAllCategory();
    return response;
  }
}
