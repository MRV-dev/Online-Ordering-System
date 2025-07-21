import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_ordering_system/pages/password.dart';
import '../globals.dart';
import '../models/orderhistorymodel.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'orders.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int selectedIndex = 0;
  late PageController _pageController;

  bool isEditing = false;

  final TextEditingController nameController = TextEditingController(
      text: 'Jane Doe');
  final TextEditingController emailController = TextEditingController(
      text: 'jane@example.com');
  final TextEditingController addressController = TextEditingController(
      text: '123 Main Street');
  final TextEditingController phoneController = TextEditingController(
      text: '+63 912 345 6789');

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? _profileImage;

  Future<void> _pickProfileImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  bool isObscureCurrent = true;
  bool isObscureNew = true;
  bool isObscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery
        .of(context)
        .size
        .width < 768;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFCA6C),
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo.jpg', height: 50),
          ],
        ),
        actions: isMobile
            ? [
          Builder(
            builder: (context) =>
                IconButton(
                  icon: const Icon(FontAwesomeIcons.bars, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
        ]
            : null,
      ),
      endDrawer: Drawer(
        backgroundColor: const Color(0xFFEFCA6C),
        width: 200,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            const SizedBox(height: 85),
            _drawerItem(context, 'Home', '/landingpage', FontAwesomeIcons.house),
            _drawerItem(context, 'Order Now', '/OrderNow', FontAwesomeIcons.cartPlus),
            _drawerItem(context, 'Contact Us', '/contactus', FontAwesomeIcons.phone),
            _drawerItem(context, 'Notifications', '/notifications', FontAwesomeIcons.bell),
            _drawerItem(context, 'Account', '/account', FontAwesomeIcons.user),
            ListTile(
              leading: const Icon(FontAwesomeIcons.arrowRightFromBracket, color: Colors.black),
              title: const Text('Logout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutModal(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildToggleButton('Profile', 0),
                _buildToggleButton('Password', 1),
                _buildToggleButton('Orders', 2),
                _buildToggleButton('Order History', 3),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              children: [
                _buildProfileSection(),
                const ChangePassword(),
                const Orders(),
                _buildOrderHistorySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
        _pageController.animateToPage(
            index, duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: selectedIndex == index
            ? const Color(0xFFEFCA6C)
            : null,
        foregroundColor: Colors.black,
      ),
      child: Text(label),
    );
  }

  Widget _buildProfileSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Profile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          GestureDetector(
            onTap: isEditing ? _pickProfileImage : null,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage:
              _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(height: 10),
          Text(nameController.text,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(isEditing ? 'Done' : 'Edit Profile'),
          ),
          const SizedBox(height: 20),
          _profileField('Name', nameController),
          _profileField('Email', emailController),
          _profileField('Address', addressController),
          _profileField('Phone Number', phoneController),
        ],
      ),
    );
  }

  Widget _profileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            enabled: isEditing,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }



  void _showTrackOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            title: const Text(
                "Track Order", style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Column(
                      children: [
                        Icon(Icons.fiber_manual_record, color: Colors.green),
                        SizedBox(height: 8),
                        Icon(Icons.fiber_manual_record, color: Colors.green),
                        SizedBox(height: 8),
                        Icon(Icons.fiber_manual_record, color: Colors.green),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Placed",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(height: 15),
                          Text("In Process",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(height: 15),
                          Text("Completed",
                              style: TextStyle(fontWeight: FontWeight.w500)),
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
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text("Close")),
            ],
          ),
    );
  }

  void _showViewOrderDialog(BuildContext context, String orderId, String method, String status) {
    // Sample items (you can later replace this with actual items from your data)
    List<Map<String, dynamic>> items = [
      {"name": "Sweet & Spicy Chami", "qty": 1, "price": 85},
      {"name": "Siomai Rice", "qty": 2, "price": 50},
      {"name": "Leche Flan", "qty": 1, "price": 60},
    ];

    int total = items.fold(0, (sum, item) => sum + ((item["qty"] * item["price"]) as int));

    String time = "4:00 PM";
    String date = "July 20, 2025";
    String address = "123 Barangay St., Calaca City";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("View Order", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID: $orderId"),
              Text("Method: $method"),
              Text("Status: $status"),
              const Divider(),
              const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...items.map((item) => Text(
                "• ${item['name']} x${item['qty']} - ₱${item['qty'] * item['price']}",
              )),
              const Divider(),
              Text("Total: ₱$total", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (method == "Delivery") ...[
                Text("Time to Deliver: $time"),
                Text("Address: $address"),
              ] else if (method == "Pickup") ...[
                Text("Time to Pickup: $time"),
              ] else if (method == "Reservation") ...[
                Text("Date to Come: $date"),
                Text("Time to Come: $time"),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }



  Widget _buildOrderHistorySection() {
    final List<Order> orders = orderHistory;

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
                        Text('Method: ${order.orderMethod}'),
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

  Widget _drawerItem(BuildContext context, String title, String route,
      IconData icon) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.black, size: 23),
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  void _showLogoutModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                // Close dialog only
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                        (route) => false, // Remove all previous routes
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}