import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_category.dart';

class PowerSocket {
  final String userId;
  final String id;
  String? name;
  PowerSocketCategory category;

  PowerSocket({
    required this.userId,
    required this.id,
    this.name,
    required this.category,
  });
}
