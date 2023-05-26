import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_manager.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_manager.dart';
import 'package:power_consumption_analyzer_frontend/request_handler.dart';

class UserRequestHandler {
  static UserRequestHandler get I {
    return GetIt.I<UserRequestHandler>();
  }

  String? _userId;

  String get userId {
    if (_userId == null) {
      debugPrint('User id is null');
      return 'null';
    }
    return _userId!;
  }

  set userId(String id) {
    _userId = id;
    debugPrint('User id is set to $id');
    PowerSocketManager.I.fetchAllPowerSocket();
    PowerSocketCategoryManager.I.fetchAllCategory();
  }

  Future<http.Response> register({
    required String username,
  }) async {
    final response = await RequestHandler.I.post('/user', {'name': username});
    debugPrint(response.body);
    if (response.statusCode == 200) {
      userId = response.body.replaceAll('"', '');
      return response;
    } else {
      throw Exception('Failed to register');
    }
  }
}
