import 'package:get_it/get_it.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';

class PowerSocketCategoryManager {
  // ignore: non_constant_identifier_names
  static PowerSocketCategoryManager get I {
    return GetIt.I<PowerSocketCategoryManager>();
  }

  String username = '';
  String ipAddress = '';
  Map<String, PowerSocketCategory> _categoryMap = {};

  Future<Map<String, PowerSocketCategory>> fetchAllCategory() async {
    _categoryMap = {
      'Living Room': PowerSocketCategory(name: 'Living Room'),
      'Bedroom': PowerSocketCategory(name: 'Bedroom'),
      'Kitchen': PowerSocketCategory(name: 'Kitchen'),
      'Bathroom': PowerSocketCategory(name: 'Bathroom'),
      'Others': PowerSocketCategory(name: 'Others'),
    };

    return Map.unmodifiable(_categoryMap);
  }

  Map<String, PowerSocketCategory> getAllCategory() {
    return Map.unmodifiable(_categoryMap);
  }

  PowerSocketCategory getCategoryByName(String name) {
    if (_categoryMap[name] == null) {
      addCategory(PowerSocketCategory(name: name));
    }
    return _categoryMap[name]!;
  }

  void addCategory(PowerSocketCategory category) {
    _categoryMap[category.name] = category;
  }
}
