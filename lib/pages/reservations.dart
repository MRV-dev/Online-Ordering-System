import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: _buildOrderList(reservations),
    );
  }


  Widget _buildOrderList(List<Order> orderList) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        final order = orderList[index];
        return _buildOrderCard(order);
      },
    );
  }


  Widget _buildOrderCard(Order order) {
    List<Widget> children = [];


    children.add(Text(
        'Reservation ID: ${order.orderId}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
    ));
    children.add(const SizedBox(height: 8));


    children.add(Text(
        'Order Method: ${order.orderMethod}',
        style: const TextStyle(fontSize: 14)
    ));
    children.add(const SizedBox(height: 8));


    children.add(Text(
        'Order Placed: ${order.orderPlaced}',
        style: const TextStyle(fontSize: 14)
    ));
    children.add(const SizedBox(height: 8));


    children.add(Text(
        'Amount: ₱${order.amount.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 14)
    ));
    children.add(const SizedBox(height: 8));


    if (order.deliveryTime != null && order.deliveryTime!.isNotEmpty) {
      children.add(Text(
          'Scheduled Time: ${order.deliveryTime}',
          style: const TextStyle(fontSize: 14)
      ));
    }
    children.add(const SizedBox(height: 8));


    if (order.date != null && order.date!.isNotEmpty) {
      children.add(Text(
          'Scheduled Date: ${order.date}',
          style: const TextStyle(fontSize: 14)
      ));
    }

    // Return the Container widget with all the children
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
        children: children,
      ),
    );
  }
}