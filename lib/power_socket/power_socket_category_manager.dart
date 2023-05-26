import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_request_handler.dart';
import 'package:power_consumption_analyzer_frontend/user_request_handler.dart';

class PowerSocketCategoryManager with ChangeNotifier {
  // ignore: non_constant_identifier_names
  static PowerSocketCategoryManager get I {
    return GetIt.I<PowerSocketCategoryManager>();
  }

  Map<String, PowerSocketCategory> _categoryMap = {};

  Future<Map<String, PowerSocketCategory>> fetchAllCategory() async {
    String userId = UserRequestHandler.I.userId;
    try {
      final response = await PowerSocketCategoryRequestHandler.I.getAllCategory(
        userId: userId,
      );
      List<dynamic> body = jsonDecode(response.body);
      _categoryMap.clear();
      for (String categoryName in body) {
        PowerSocketCategory category = PowerSocketCategory(
          userId: userId,
          name: categoryName,
        );
        _categoryMap[categoryName] = category;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
    return Map.unmodifiable(_categoryMap);
  }

  Map<String, PowerSocketCategory> getAllCategory() {
    return Map.unmodifiable(_categoryMap);
  }

  List<PowerSocketCategory> getAllCategoryList() {
    return _categoryMap.values.toList();
  }

  PowerSocketCategory getCategoryByName(String name) {
    if (_categoryMap[name] == null) {
      String userId = UserRequestHandler.I.userId;
      addCategory(PowerSocketCategory(
        userId: userId,
        name: name,
      ));
    }
    return _categoryMap[name]!;
  }

  void addCategory(PowerSocketCategory category) {
    _categoryMap[category.name] = category;
  }
}
