import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globals.dart';
import '../models/orderhistorymodel.dart';
import 'dart:async';
import 'package:collection/collection.dart';


ValueNotifier<bool> isFoodReadyNotifier = ValueNotifier(false);
Map<String, ValueNotifier<bool>> orderReadinessMap = {};
Map<String, ValueNotifier<int>> deliveryProgressMap = {};
Map<String, Timer> deliveryTimers = {};

void startFoodReadinessTimer(String orderId) {
  orderReadinessMap[orderId] = ValueNotifier<bool>(false);

  Future.delayed(Duration(seconds: 15), () {
    final notifier = orderReadinessMap[orderId];
    if (notifier != null) {
      notifier.value = true;
    }
  });
}

void startDeliveryTimer(String orderId) {
  if (deliveryProgressMap.containsKey(orderId)) return;

  final notifier = ValueNotifier<int>(0);
  deliveryProgressMap[orderId] = notifier;

  Timer timer = Timer.periodic(Duration(seconds: 15), (timer) {
    final currentProgress = notifier.value;
    if (currentProgress >= 2) {
      timer.cancel();
      deliveryTimers.remove(orderId);


      final orderToRemove = orders.firstWhereOrNull((o) => o.orderId == orderId);
      if (orderToRemove != null) {
        orders.remove(orderToRemove);
        orderHistory.add(orderToRemove);
        deliveryProgressMap.remove(orderId);
      }
    } else {
      notifier.value = currentProgress + 1;
    }
  });

  deliveryTimers[orderId] = timer;
}


class Orders extends StatefulWidget {
  const Orders({super.key});

@override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  bool isPlacedGreen = false;
  bool isInProcessGreen = false;
  bool isCompletedGreen = false;
  bool isCompleteButtonEnabled = false;
  bool isPickupCompleteButtonEnabled = false;
  bool isPickupReady = false;
  bool isPickupInProcess = false;


  @override
  void initState() {
    super.initState();

    for (var order in orders) {
      if (order.orderMethod == "Delivery") {
        startDeliveryTimer(order.orderId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            const Text(
              'Orders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            orders.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order, context);
              },
            )
                : Center(
              child: Text(
                'No orders found.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOrderCard(Order order, BuildContext context) {
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Track Order Button
              IconButton(
                icon: const Icon(FontAwesomeIcons.eye),
                onPressed: () {
                  if (order.orderMethod == "Pick Up") {
                    _showPickupDialog(context, order);
                  } else{
                    _showTrackOrderDialog(context, order, _updateOrders);
                    }
                  } ,
                iconSize: 18,
              ),
              // View Order Icon
              IconButton(
                icon: const Icon(FontAwesomeIcons.receipt),
                onPressed: () {
                  _showViewOrderDialog(context, order);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _updateOrders(Order order) {
    setState(() {
      if (order.orderMethod == "Reservation") {
        reservations.remove(order);  // Remove the order from reservations list
      } else {
        orders.remove(order);  // Remove the order from orders list
      }
      orderHistory.add(order);  // Add to order history list
    });
  }


  void _showTrackOrderDialog(BuildContext context, Order order, void Function(Order order) updateOrders) {
    final deliveryProgressNotifier = deliveryProgressMap[order.orderId];

    if (deliveryProgressNotifier == null) {
      startDeliveryTimer(order.orderId);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ValueListenableBuilder<int>(
          valueListenable: deliveryProgressMap[order.orderId] ?? ValueNotifier(0),
          builder: (context, progress, _) {
            bool isPlacedGreen = progress >= 0;
            bool isInProcessGreen = progress >= 1;
            bool isCompletedGreen = progress >= 2;
            bool showDeliveredMessage = isCompletedGreen;

            // When completed, auto close the dialog & remove order after a short delay
            if (isCompletedGreen) {
              Future.delayed(Duration(seconds: 3), () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // close dialog
                }
                updateOrders(order); // Call updateOrders to update the order list
                deliveryProgressMap.remove(order.orderId);
              });
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text("Track Order", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(FontAwesomeIcons.circle, color: isPlacedGreen ? Colors.green : Colors.grey),
                          SizedBox(height: 8),
                          Icon(FontAwesomeIcons.circle, color: isInProcessGreen ? Colors.green : Colors.grey),
                          SizedBox(height: 8),
                          Icon(FontAwesomeIcons.circle, color: isCompletedGreen ? Colors.green : Colors.grey),
                        ],
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order Placed", style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 15),
                            Text("In Process", style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 15),
                            Text("Completed", style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (showDeliveredMessage)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(child: Text("Your order has been delivered")),
                        ],
                      ),
                    ),
                  if (!showDeliveredMessage)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(child: Text("Your order is being processed")),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                if (!showDeliveredMessage)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"),
                  ),
              ],
            );
          },
        );
      },
    );
  }





  void _showPickupDialog(BuildContext context, Order order) {
    // Make sure the readiness notifier exists for this order
    final readinessNotifier = orderReadinessMap[order.orderId];

    if (readinessNotifier == null) {
      // If not already started, start the timer
      startFoodReadinessTimer(order.orderId);
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Pickup Order", style: TextStyle(fontWeight: FontWeight.bold)),
        content: ValueListenableBuilder<bool>(
          valueListenable: orderReadinessMap[order.orderId]!,
          builder: (context, isFoodReady, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isFoodReady
                    ? "Your food is ready for pickup"
                    : "Your food is still in process"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isFoodReady
                      ? () {
                    _updateOrders(order);
                    Navigator.pop(context);
                  }
                      : null,
                  child: const Text("Pickup Complete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFoodReady ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }









  // View Order Dialog (order details)
  void _showViewOrderDialog(BuildContext context, Order order) {
    List<Map<String, dynamic>> items = [];
    for (var dish in order.dishes) {
      // Create items based on the dishes list
      items.add({"name": dish, "qty": 1, "price": 100});
    }

    int total = items.fold(0, (sum, item) => sum + ((item["qty"] * item["price"]) as int));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("View Order", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID: ${order.orderId}"),
              Text("Method: ${order.orderMethod}"),
              Text("Status: ${order.status}"),
              const Divider(),
              const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...items.map((item) => Text("• ${item['name']} x${item['qty']} - ₱${item['qty'] * item['price']}")),
              const Divider(),
              Text("Total: ₱$total", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (order.orderMethod == "Delivery") ...[
                Text("Time to Deliver: ${order.deliveryTime}"),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }
}
