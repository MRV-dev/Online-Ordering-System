import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globals.dart';
import '../models/orderhistorymodel.dart';
import 'dart:async';
import 'package:collection/collection.dart';


ValueNotifier<bool> isFoodReadyNotifier = ValueNotifier(false);
Map<String, ValueNotifier<int>> deliveryProgressMap = {};
Map<String, Timer> deliveryTimers = {};
Map<String, ValueNotifier<bool>> orderReadinessMap = {};
Map<String, ValueNotifier<bool>> orderCompletionMap = {};

void startFoodReadinessTimer(String orderId) {
  orderReadinessMap[orderId] = ValueNotifier<bool>(false);

  Future.delayed(Duration(seconds: 14), () {
    final notifier = orderReadinessMap[orderId];
    if (notifier != null) {
      notifier.value = true;
    }
  });
}

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  bool isPlacedGreen = false;
  bool isInProcessGreen = false;
  bool isoutfordeliveryGreen = false;
  bool isCompletedGreen = false;
  bool isCompleteButtonEnabled = false;
  bool isPickupCompleteButtonEnabled = false;
  bool isPickupReady = false;
  bool isPickupInProcess = false;


  void startDeliveryTimer(String orderId) {
    if (deliveryProgressMap.containsKey(orderId)) return;

    final notifier = ValueNotifier<int>(0);
    deliveryProgressMap[orderId] = notifier;
    orderCompletionMap[orderId] = ValueNotifier<bool>(false);

    Timer timer = Timer.periodic(Duration(seconds: 10), (timer) {
      final currentProgress = notifier.value;

      if (currentProgress >= 3) {
        timer.cancel();
        deliveryTimers.remove(orderId);

        // Mark the order as completed
        orderCompletionMap[orderId]?.value = true;

        // Wait for 1 second, then remove the order from active list
        Future.delayed(Duration(seconds: 1), () {
          final orderToRemove = orders.firstWhereOrNull((o) => o.orderId == orderId);
          if (orderToRemove != null) {
            setState(() {
              orders.remove(orderToRemove);  // Remove from active orders
              orderHistory.add(orderToRemove);  // Add to order history
            });
          }

          // Clean up progress tracking for this order
          deliveryProgressMap.remove(orderId);
        });
      } else {
        notifier.value = currentProgress + 1;
      }
    });

    deliveryTimers[orderId] = timer;
  }





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
      backgroundColor: const Color(0xFFFFFBEB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            const Text(
              'Orders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.where((order) => order.orderMethod != 'Reservation').length +
                  pickUpOrders.length, // We are only counting non-reservation orders
              itemBuilder: (context, index) {
                // Get the order and display it
                Order order;
                if (index < orders.where((order) => order.orderMethod != 'Reservation').length) {
                  order = orders.where((order) => order.orderMethod != 'Reservation').toList()[index];
                } else {
                  order = pickUpOrders[index - orders.where((order) => order.orderMethod != 'Reservation').length];
                }

                return _buildOrderCard(order, context);
              },
            ),
            // Display a message if no orders are found
            orders.isEmpty && pickUpOrders.isEmpty
                ? Center(child: Text('No orders found.'))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }


  Widget _buildOrderCard(Order order, BuildContext context) {
    final orderCompletionNotifier = orderCompletionMap[order.orderId];

    return ValueListenableBuilder<bool>(
      valueListenable: orderCompletionNotifier ?? ValueNotifier(false),
      builder: (context, isCompleted, _) {
        // When the order is completed, we will remove it automatically
        if (isCompleted) {
          // Ensure the order is not already in history before adding it
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              // Remove the order from active orders
              orders.removeWhere((o) => o.orderId == order.orderId);

              // Add the order to history only if it's not already there
              if (!orderHistory.any((o) => o.orderId == order.orderId)) {
                orderHistory.add(order);  // Add to order history
              }
            });
          });
        }

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
              if (order.orderMethod == "Pick Up")
                Text('Scheduled Pickup: ${order.deliveryTime}', style: const TextStyle(fontSize: 14))
              else if (order.deliveryTime != null && order.deliveryTime!.isNotEmpty)
                Text('Delivery Time: ${order.deliveryTime}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.eye),
                    onPressed: () {
                      if (order.orderMethod == "Pick Up") {
                        _showPickupDialog(context, order);
                      } else {
                        _showTrackOrderDialog(context, order, _updateOrders);
                      }
                    },
                    iconSize: 18,
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.receipt),
                    onPressed: () {
                      if (order.dishes.isNotEmpty) {
                        _showViewOrderDialog(context, order);
                      }
                    },
                  ),
                ],
              ),
              if (isCompleted)
                Text(
                  'Completed',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        );
      },
    );
  }




  void _updateOrders(Order order) {
    setState(() {
      if (order.orderMethod == "Reservation") {
        reservations.remove(order);
      } else {
        orders.remove(order);
      }
      orderHistory.add(order);
    });
  }


  void _showTrackOrderDialog(BuildContext context, Order order, void Function(Order order) updateOrders) {
    final deliveryProgressNotifier = deliveryProgressMap[order.orderId];

    if (deliveryProgressNotifier == null) {
      startDeliveryTimer(order.orderId);  // Start the timer for each order
    }

    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder<int>(
          valueListenable: deliveryProgressMap[order.orderId] ?? ValueNotifier(0),
          builder: (context, progress, _) {
            bool isPlacedGreen = progress >= 0;
            bool isInProcessGreen = progress >= 1;
            bool isOutForDeliveryGreen = progress >= 2;
            bool isCompletedGreen = progress >= 3;

            return AlertDialog(
              backgroundColor: Colors.white,
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
                          Icon(FontAwesomeIcons.circle, color: isOutForDeliveryGreen ? Colors.green : Colors.grey),
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
                            Text("Out For Delivery", style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 15),
                            Text("Completed", style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (isCompletedGreen)
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
                  if (!isCompletedGreen)
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
                if (!isCompletedGreen)
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
    final readinessNotifier = orderReadinessMap[order.orderId];

    if (readinessNotifier == null) {
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
                    setState(() {
                      pickUpOrders.remove(order);
                      orderHistory.add(order);
                    });
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


  void _showViewOrderDialog(BuildContext context, Order order) {

    if (order == null || order.dishes.isEmpty || order.quantities.isEmpty) {
      print("No valid order data available.");
      return;
    }

    print("Order Dishes: ${order.dishes}");
    print("Order Quantities: ${order.quantities}");

    // Show the dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold)),
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
              // Display dish names and quantities
              if (order.dishes.isEmpty)
                Text("No items in this order.")
              else
                ...order.dishes.map((dish) {
                  int quantity = order.quantities[dish] ?? 0;  // Get quantity from order.quantities
                  return Text("• $dish x$quantity");
                }),
              const Divider(),
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