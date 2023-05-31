class PowerSocketCategory {
  final String userId;
  final String name;
  double totalPowerConsumption = 0;
  double totalBill = 0;

  PowerSocketCategory({
    required this.userId,
    required this.name,
    required this.totalPowerConsumption,
    required this.totalBill,
  });
}
