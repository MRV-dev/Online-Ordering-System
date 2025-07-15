class Order {
  final String orderId;
  final String orderMethod;
  final String orderPlaced;
  final double amount;
  late final String status;
  final List<String> dishes;

  Order({
    required this.orderId,
    required this.orderMethod,
    required this.orderPlaced,
    required this.amount,
    required this.status,
    required this.dishes
  });
}