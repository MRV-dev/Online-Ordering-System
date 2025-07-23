import 'package:flutter/material.dart';
import 'package:online_ordering_system/models/orderhistorymodel.dart';
import '../globals.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key, required List<Order> orders});

  final List<Order> orders = orderHistory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  child: ListTile(
                    title: Text('Order ID: ${order.orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Method: ${_getOrderMethod(order)}'),
                        Text('Amount: ₱${order.amount.toStringAsFixed(2)}'),
                        Text('Status: ${order.status}'),
                        Text('Placed: ${order.orderPlaced}'),
                      ],
                    ),
                    onTap: () => _showOrderDetailsModal(context, order),
                  ),
                );
              },
            )
          else
            const Text('No orders found.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  // Helper method to build individual order cards
  Widget _buildOrderCard(String orderId, String orderMethod, String orderPlaced, String amount, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: $orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Order Method: $orderMethod', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Reserved For: $orderPlaced', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Amount: $amount', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
