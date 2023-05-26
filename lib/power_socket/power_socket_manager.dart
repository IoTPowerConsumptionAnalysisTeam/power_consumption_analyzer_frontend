import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_manager.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_request_handler.dart';
import 'package:power_consumption_analyzer_frontend/user_request_handler.dart';
import 'dart:convert';

class PowerSocketManager with ChangeNotifier {
  // ignore: non_constant_identifier_names
  static PowerSocketManager get I {
    return GetIt.I<PowerSocketManager>();
  }

  Map<String, PowerSocket> _powerSocketMap = {};

  Future<Map<String, PowerSocket>> fetchAllPowerSocket() async {
    String userId = UserRequestHandler.I.userId;
    try {
      final response = await PowerSocketRequestHandler.I.getAllPowerSocket(
        userId: userId,
      );
      List<dynamic> body = jsonDecode(response.body);
      _powerSocketMap.clear();
      for (String powerSocketId in body) {
        final response = await PowerSocketRequestHandler.I.getPowerSocket(
          userId: userId,
          powerSocketId: powerSocketId,
        );
        Map<String, dynamic> powerSocketJson = jsonDecode(response.body);
        PowerSocket powerSocket = PowerSocket(
          userId: userId,
          id: powerSocketId,
          name: powerSocketJson['name'],
          category: powerSocketJson['category'],
        );
        _powerSocketMap[powerSocketId] = powerSocket;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    debugPrint('fetch all power socket done');
    debugPrint('total power socket: ${_powerSocketMap.length}');
    notifyListeners();
    return Map.unmodifiable(_powerSocketMap);
  }

  Map<String, PowerSocket> getAllPowerSocket() {
    return Map.unmodifiable(_powerSocketMap);
  }

  PowerSocket getPowerSocketById(
    String id, {
    bool createIfNotExist = false,
    String? name,
    String categoryName = 'Others',
  }) {
    if (_powerSocketMap[id] == null && createIfNotExist) {
      String userId = UserRequestHandler.I.userId;
      addPowerSocket(PowerSocket(
        userId: userId,
        id: id,
        name: name,
        category: categoryName,
      ));
    }
    return _powerSocketMap[id]!;
  }

  List<PowerSocket> getPowerSocketsByCategory(String categoryName) {
    return _powerSocketMap.values
        .where((powerSocket) => powerSocket.category == categoryName)
        .toList();
  }

  List<PowerSocket> getPowerSocketsExceptCategories(
      List<String> categoryNames) {
    return _powerSocketMap.values
        .where((powerSocket) => !categoryNames.contains(powerSocket.category))
        .toList();
  }

  void addPowerSocket(PowerSocket powerSocket) {
    _powerSocketMap[powerSocket.id] = powerSocket;
  }
}
