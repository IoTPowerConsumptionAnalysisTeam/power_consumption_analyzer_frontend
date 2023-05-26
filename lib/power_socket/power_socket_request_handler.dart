import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_manager.dart';
import 'package:power_consumption_analyzer_frontend/request_handler.dart';

class PowerSocketRequestHandler {
  static PowerSocketRequestHandler get I {
    return GetIt.I<PowerSocketRequestHandler>();
  }

  Future<http.Response> registerPowerSocket({
    required String userId,
    required String powerSocketName,
    required String powerSocketCategoryName,
  }) async {
    final response = await RequestHandler.I.post(
      '/user/$userId/power_socket',
      {
        'category': powerSocketCategoryName,
        'name': powerSocketName,
      },
    );
    PowerSocketManager.I.fetchAllPowerSocket();
    return response;
  }

  Future<http.Response> getAllPowerSocket({
    required String userId,
  }) async {
    final response = await RequestHandler.I.get(
      '/user/$userId/power_socket',
    );
    return response;
  }

  Future<http.Response> getPowerSocket({
    required String userId,
    required String powerSocketId,
  }) async {
    final response = await RequestHandler.I.get(
      '/user/$userId/power_socket/$powerSocketId',
    );
    return response;
  }

  Future<http.Response> updatePowerSocket({
    required String userId,
    required String powerSocketId,
    String? name,
    String? category,
  }) async {
    Map<String, dynamic> body = {};
    if (name != null) {
      body['name'] = name;
    }
    if (category != null) {
      body['category'] = category;
    }
    final response = await RequestHandler.I.patch(
      '/user/$userId/power_socket/$powerSocketId',
      body,
    );
    PowerSocketManager.I.fetchAllPowerSocket();
    return response;
  }

  Future<http.Response> deletePowerSocket({
    required String userId,
    required String powerSocketId,
  }) async {
    final response = await RequestHandler.I.delete(
      '/user/$userId/power_socket/$powerSocketId',
    );
    PowerSocketManager.I.fetchAllPowerSocket();
    return response;
  }

  Future<http.Response> deleteAllPowerSocket({
    required String userId,
  }) async {
    final response = await RequestHandler.I.delete(
      '/user/$userId/power_socket',
    );
    PowerSocketManager.I.fetchAllPowerSocket();
    return response;
  }
}
