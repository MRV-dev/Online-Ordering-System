import 'package:flutter/material.dart';
import '../globals.dart';
import '../models/orderhistorymodel.dart';



class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: _buildOrderList(reservations),
    );
  }

  // Function to build the list of orders or reservations
  Widget _buildOrderList(List<Order> orderList) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        final order = orderList[index];
        return _buildOrderCard(order);
      },
    );
  }

  // Function to display the order card
  Widget _buildOrderCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text('Order ID: ${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Order Method: ${order.orderMethod}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Order Placed: ${order.orderPlaced}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Amount: ₱${order.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          if (order.deliveryTime != null && order.deliveryTime!.isNotEmpty)
            Text('Delivery Time: ${order.deliveryTime}', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

