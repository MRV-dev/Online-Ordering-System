import 'package:flutter/material.dart';
import 'package:online_ordering_system/models/orderhistorymodel.dart';
import '../globals.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key, required List<Order> orders, required List<Order> pickUpOrders});

  final List<Order> orders = orderHistory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (orders.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  color: Colors.white,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between the items
                      children: [
                        Text(
                          'Order ID: ${order.orderId}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Placed text at the top right
                        Text(
                          '${order.orderPlaced}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Method: ${_getOrderMethod(order)}'),
                        Text('Amount: ₱${order.amount.toStringAsFixed(2)}'),
                        Row(
                          children: [
                            Text('Status: '),
                            Text('Processed', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _showOrderDetailsModal(context, order),
                  ),
                );
              },
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 260),
                const Text(
                  'No orders in your history yet. Start ordering now!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        ],
      ),
    );
  }




  // Determine order method and display the appropriate text
  String _getOrderMethod(Order order) {
    switch (order.orderMethod) {
      case 'Reservation':
        return 'Reservation';
      case 'Pick Up':
        return 'Pick Up';
      case 'Delivery':
      default:
        return 'Delivery';
    }
  }

  void _showOrderDetailsModal(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text('Order Details - ${order.orderId}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...order.dishes.map((dish) {
                  final dishPrice = _getItemPrice(dish);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('$dish - ₱${dishPrice.toStringAsFixed(2)}'),
                  );
                }).toList(),
                const Divider(),
                Text('Total: ₱${order.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text('Close')),
            ],
          ),
    );
  }

  double _getItemPrice(String itemName) {
    double price = 0.0;
    final dish = dishes.firstWhere((d) => d['name'] == itemName,
        orElse: () => {});
    if (dish.isNotEmpty) {
      price = double.tryParse(dish['price']?.substring(1) ?? '0') ?? 0.0;
    } else {
      final bilaoItem = bilao.firstWhere((b) => b['name'] == itemName,
          orElse: () => {});
      if (bilaoItem.isNotEmpty) {
        price = double.tryParse(bilaoItem['price']?.substring(1) ?? '0') ?? 0.0;
      } else {
        final dessertItem = desserts.firstWhere((d) => d['name'] == itemName,
            orElse: () => {});
        if (dessertItem.isNotEmpty) {
          price =
              double.tryParse(dessertItem['price']?.substring(1) ?? '0') ?? 0.0;
        }
      }
    }
    return price;
  }
}
