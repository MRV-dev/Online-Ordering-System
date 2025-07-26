class Order {
  final String orderId;
  late final String orderMethod;
  final String orderPlaced;
  final double amount;
  late final String status;
  final List<String> dishes;
  final String? deliveryTime;
  final String? date;
  final Map<String, int> quantities;

  Order({
    required this.orderId,
    required this.orderMethod,
    required this.orderPlaced,
    required this.amount,
    required this.status,
    required this.dishes,
    this.deliveryTime,
    this.date,
    required this.quantities,
  });
}
