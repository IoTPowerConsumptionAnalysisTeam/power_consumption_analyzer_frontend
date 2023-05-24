import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category_manager.dart';

class PowerSocketManager {
  // ignore: non_constant_identifier_names
  static PowerSocketManager get I {
    return GetIt.I<PowerSocketManager>();
  }

  String username = '';
  String ipAddress = '';
  Map<String, PowerSocket> _powerSocketMap = {};

  Future<Map<String, PowerSocket>> fetchAllPowerSocket() async {
    _powerSocketMap = {
      'Living Room 1': PowerSocket(
        id: 'Living Room 1',
        category: PowerSocketCategoryManager.I.getCategoryByName('Living Room'),
      ),
      'Living Room 2': PowerSocket(
        id: 'Living Room 2',
        category: PowerSocketCategoryManager.I.getCategoryByName('Living Room'),
      ),
      'Bedroom 1': PowerSocket(
        id: 'Bedroom 1',
        category: PowerSocketCategoryManager.I.getCategoryByName('Bedroom'),
      ),
      'Bedroom 2': PowerSocket(
        id: 'Bedroom 2',
        category: PowerSocketCategoryManager.I.getCategoryByName('Bedroom'),
      ),
      'Kitchen 1': PowerSocket(
        id: 'Kitchen 1',
        category: PowerSocketCategoryManager.I.getCategoryByName('Kitchen'),
      ),
      'Kitchen 2': PowerSocket(
        id: 'Kitchen 2',
        category: PowerSocketCategoryManager.I.getCategoryByName('Kitchen'),
      ),
    };
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
    if (_powerSocketMap[id] == null) {
      addPowerSocket(PowerSocket(
        id: id,
        name: name,
        category: PowerSocketCategoryManager.I.getCategoryByName(categoryName),
      ));
    }
    return _powerSocketMap[id]!;
  }

  List<PowerSocket> getPowerSocketsByCategory(String categoryName) {
    return _powerSocketMap.values
        .where((powerSocket) => powerSocket.category.name == categoryName)
        .toList();
  }

  void addPowerSocket(PowerSocket powerSocket) {
    _powerSocketMap[powerSocket.id] = powerSocket;
  }
}
