import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';

class PowerSocket {
  final String userId;
  final String id;
  String? name;
  String category;
  double totalPowerConsumption = 0;
  double totalBill = 0;

  PowerSocket({
    required this.userId,
    required this.id,
    this.name,
    required this.category,
    required this.totalPowerConsumption,
    required this.totalBill,
  });
}
