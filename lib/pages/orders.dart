import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../globals.dart';
import '../models/orderhistorymodel.dart';
import 'dart:async';

class Orders extends StatefulWidget {
  const Orders({super.key});

@override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  Timer? _timer;
  int _secondsElapsed = 0;
  bool isPlacedGreen = false;
  bool isInProcessGreen = false;
  bool isCompletedGreen = false;
  late Order _currentOrder;
  bool isCompleteButtonEnabled = false;
  bool isPickupCompleteButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimerForOrder();
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


  // Helper method to build individual order cards
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
          // Order ID
          Text('Order ID: ${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          // Order Method
          Text('Order Method: ${order.orderMethod}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          // Order Placed
          Text('Order Placed: ${order.orderPlaced}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          // Amount
          Text('Amount: ₱${order.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          // Display Delivery Time if available
          if (order.deliveryTime != null && order.deliveryTime!.isNotEmpty)
            Text('Delivery Time: ${order.deliveryTime}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          // Row with action buttons: Track Order and View Order
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Track Order Button
              IconButton(
                icon: const Icon(FontAwesomeIcons.eye),
                onPressed: () => _showTrackOrderDialog(context, order, _updateOrders),
                iconSize: 18,
              ),
// View Order Icon
              IconButton(
                icon: const Icon(FontAwesomeIcons.receipt),
                onPressed: () {
                  // Check if the order method is "Pickup"
                  if (order.orderMethod == "Pickup") {
                    // Call the Pickup dialog for this order
                    _showPickupDialog(context, order);
                  } else {
                    // Otherwise, show the regular order details dialog
                    _showViewOrderDialog(context, order);
                  }
                },
              ),

            ],
          ),
        ],
      ),
    );
  }

  // Track Order Dialog
  void _startTimerForOrder() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsElapsed == 5 && !isPlacedGreen) {
        setState(() {
          isPlacedGreen = true;
        });
      }
      if (_secondsElapsed == 10 && !isInProcessGreen) {
        setState(() {
          isInProcessGreen = true;
        });
      }
      if (_secondsElapsed == 15 && !isCompletedGreen) {
        setState(() {
          isCompletedGreen = true;
        });
      }

      // After all steps are completed, enable the "Complete" button
      if (_secondsElapsed == 20) {
        setState(() {
          isCompleteButtonEnabled = true; // Enable the "Complete" button
          isPickupCompleteButtonEnabled = true; // Enable the Pickup button
        });
      }

      _secondsElapsed++;
    });
  }

  // Update the orders list after completion
  void _updateOrders(Order order) {
    setState(() {
      orders.remove(order);  // Remove the order from the orders list
      orderHistory.add(order);  // Add the order to the order history
    });
  }

  // Show the Track Order Dialog and update order states
  void _showTrackOrderDialog(BuildContext context, Order order, void Function(Order order) updateOrders) {
    setState(() {
      _currentOrder = order;
    });

    // Start the timer only once, outside the dialog
    if (_secondsElapsed == 0) {
      _startTimerForOrder(); // Start the timer when the dialog is shown
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Track Order", style: TextStyle(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.circle,
                          color: isPlacedGreen ? Colors.green : Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Icon(
                          FontAwesomeIcons.circle,
                          color: isInProcessGreen ? Colors.green : Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Icon(
                          FontAwesomeIcons.circle,
                          color: isCompletedGreen ? Colors.green : Colors.grey,
                        ),
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
                const SizedBox(height: 20),
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
                      Expanded(child: Text("Your order has been completed")),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isCompleteButtonEnabled
                      ? () {
                    // When "Complete" button is pressed, move the order to history
                    _updateOrders(order);
                    Navigator.pop(context); // Close the dialog
                  }
                      : null, // Make the button disabled if not yet completed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleteButtonEnabled ? Colors.green : Colors.grey,
                  ),
                  child: const Text("Complete", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isPickupCompleteButtonEnabled
                      ? () {
                    // Move to history and remove from current list
                    _updateOrders(order);
                    Navigator.pop(context); // Close the dialog
                  }
                      : null, // Make the button disabled if not yet processed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPickupCompleteButtonEnabled ? Colors.green : Colors.grey,
                  ),
                  child: const Text("Pickup Complete", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }


  void _showPickupDialog(BuildContext context, Order order) {
    bool isFoodReady = false; // Track whether the food is ready for pickup

    // Show the dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Pickup Order", style: TextStyle(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setState) {
            // Start the process when the dialog is opened
            Future.delayed(Duration(seconds: 4), () {
              setState(() {
                isFoodReady = true; // Change the status after 4 seconds
              });
            });

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isFoodReady
                    ? "Your food is ready for pickup" // Updated message when food is ready
                    : "Your food is still in process"), // Initial message
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isFoodReady
                      ? () {
                    // When food is ready, move it to history and remove from current orders
                    _updateOrders(order);
                    Navigator.pop(context); // Close the dialog
                  }
                      : null, // Disable button if food is not ready yet
                  child: const Text("Pickup Complete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFoodReady ? Colors.green : Colors.grey, // Change color based on status
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
