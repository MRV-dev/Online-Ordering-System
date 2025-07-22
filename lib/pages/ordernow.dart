import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../globals.dart';
import '../models/orderhistorymodel.dart';
import 'order_history.dart';
import 'orders.dart';


class Ordernow extends StatefulWidget {
  const Ordernow({super.key});

  @override
  State<Ordernow> createState() => _OrdernowState();
}

class _OrdernowState extends State<Ordernow> with TickerProviderStateMixin {
  String selectedCategory = 'Dishes';
  String deliveryOption = 'Delivery';
  final ImagePicker _picker = ImagePicker();
  File? _image;


  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    } else {
      print("No image selected.");
    }
  }

  String _formatTime(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    final String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }


  final Map<String, int> quantities = {
    'Lomi': 0,
    'Sweet & Spicy': 0,
    'Plain': 0,
    'Bihon': 0,
    'Tapsilog': 0,
    'Hotsilog': 0,
    'Siomaisilog': 0,
    'Siomai Rice': 0,
    'Pancit Bilao': 0,
    'Spaghetti Bilao': 0,
    'Palabok Bilao': 0,
    'Chami Bilao': 0,
    'Graham': 0,
    'Leche Plan': 0,
    'Graham Bar': 0,
    'Maja Blanca': 0,
  };

  final List<Map<String, String>> dishes = [
    {'name': 'Lomi', 'price': '₱75.00', 'image': 'assets/images/lomi.jpg'},
    {'name': 'Sweet & Spicy', 'price': '₱115.00', 'image': 'assets/images/sweet_and_spicy.png'},
    {'name': 'Plain', 'price': '₱110.00', 'image': 'assets/images/plain.png'},
    {'name': 'Bihon', 'price': '₱90.00', 'image': 'assets/images/bihon.png'},
    {'name': 'Tapsilog', 'price': '₱95.00', 'image': 'assets/images/tapsilog.png'},
    {'name': 'Hotsilog', 'price': '₱75.00', 'image': 'assets/images/hotsilog.png'},
    {'name': 'Siomaisilog', 'price': '₱70.00', 'image': 'assets/images/siomaisilog.png'},
    {'name': 'Siomai Rice', 'price': '₱55.00', 'image': 'assets/images/siomai-rice.png'},
  ];

  final List<Map<String, String>> bilao = [
    {'name': 'Pancit Bilao', 'price': '₱250.00', 'image': 'assets/images/Pancit_bilao.png',},
    {'name': 'Spaghetti Bilao', 'price': '₱280.00', 'image': 'assets/images/Spaghetti_bilao.png',},
    {'name': 'Palabok Bilao', 'price': '₱300.00', 'image': 'assets/images/palabok_bilao.png',},
    {'name': 'Chami Bilao', 'price': '₱270.00', 'image': 'assets/images/chami_bilao.png',},
  ];

  final List<Map<String, String>> desserts = [
    {'name': 'Graham', 'price': '₱75.00', 'image': 'assets/images/graham.png'},
    {'name': 'Leche Plan', 'price': '₱100.00', 'image': 'assets/images/leche-flan.png'},
    {'name': 'Graham Bar', 'price': '₱25.00', 'image': 'assets/images/graham-bar.png'},
    {'name': 'Maja Blanca', 'price': '₱100.00', 'image': 'assets/images/maja.jpg'},
  ];


  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetAnimation() {
    _controller.reset();
    _controller.forward();
  }

  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7D6),
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
            _drawerItem(
                context, 'Home', '/landingpage', FontAwesomeIcons.house),
            _drawerItem(
                context, 'Order Now', '/OrderNow', FontAwesomeIcons.cartPlus),
            _drawerItem(context, 'Notifications', '/notifications',
                FontAwesomeIcons.bell),
            _drawerItem(context, 'Account', '/profile', FontAwesomeIcons.user),
            ListTile(
              leading: const Icon(
                  FontAwesomeIcons.arrowRightFromBracket, color: Colors.black),
              title: const Text('Logout',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutModal(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Category Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['Dishes', 'Bilao', 'Desserts'].map((category) {
                  final isSelected = selectedCategory == category;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEFCA6C) : Colors
                              .white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors
                                  .grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            selectedCategory == 'Dishes'
                ? _buildDishesGrid(
                isMobile) //show the Dishes Grid when selected
                : selectedCategory == 'Bilao'
                ? _buildBilaoGrid(isMobile)
                : selectedCategory == 'Desserts'
                ? _buildDessertsGrid(isMobile)// show the Bilao Grid when selected
                : Container(), // desserts empty for now
          ],
        ),
      ),
      floatingActionButton: Opacity(
        opacity: 0.75,
        child: FloatingActionButton(
          onPressed: () => _showSummarySidebar(context),
          backgroundColor: const Color(0xFFEFCA6C),
          foregroundColor: Colors.black,
          child: const Icon(FontAwesomeIcons.receipt),
        ),
      ),
      floatingActionButtonLocation: const OffsetFloatingActionButtonLocation(
        xOffset: 30,
        yOffset: -200,
      ),
    );
  }

  Widget _buildDishesGrid(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
      child: GridView.count(
        crossAxisCount: isMobile ? 2 : 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.69,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: dishes.map((dish) {
          final name = dish['name']!;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 1),
                Image.asset(dish['image']!, height: 90, fit: BoxFit.cover),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(dish['price']!, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circleMinus, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (quantities[name]! > 0) {
                            quantities[name] = quantities[name]! - 1;
                          }
                        });
                      },
                    ),
                    Text('${quantities[name]}'),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circlePlus, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          quantities[name] = quantities[name]! + 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBilaoGrid(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
      child: GridView.count(
        crossAxisCount: isMobile ? 2 : 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: bilao.map((bilao) {
          final name = bilao['name']!;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(bilao['image']!, height: 80, fit: BoxFit.cover),
                const SizedBox(height: 8,),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(bilao['price']!, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circleMinus, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (quantities[name]! > 0) {
                            quantities[name] = quantities[name]! - 1;
                          }
                        });
                      },
                    ),
                    Text('${quantities[name]}'),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circlePlus, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          quantities[name] = quantities[name]! + 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildDessertsGrid(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
      child: GridView.count(
        crossAxisCount: isMobile ? 2 : 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.69,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: desserts.map((dessert) {
          final name = dessert['name']!;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(dessert['image']!, height: 90, fit: BoxFit.cover),
                const SizedBox(height: 8,),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(dessert['price']!, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circleMinus, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (quantities[name]! > 0) {
                            quantities[name] = quantities[name]! - 1;
                          }
                        });
                      },
                    ),
                    Text('${quantities[name]}'),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.circlePlus, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          quantities[name] = quantities[name]! + 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }



  //Checkout modal
  void _checkout() {
    if (_hashItems()) {
      _showCheckoutModal();
    } else {
      Navigator.pop(context);
      _showCustomSnackBar('Please add items to your order.');
    }
  }

  void _showCustomSnackBar(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 45),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }


  bool _hashItems() {
    return quantities.values.any((quantity) => quantity > 0);
  }


  void _showCheckoutModal() {
    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    String selectedTime = '';

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null && picked != TimeOfDay.now()) {
        setState(() {
          selectedTime = _formatTime(picked);
          timeController.text = selectedTime;
        });
      }
    }



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 330,
                child: Material(
                  color: Colors.white,
                  elevation: 13,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10), right: Radius.circular(10),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 13),
                            margin: EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black26),
                              color: Color(0xFFEFCA6C),
                            ),
                            child: const Text(
                              'Delivery',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          // Full Name
                          TextField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Phone Number
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          // Delivery Address
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: 'Delivery Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Delivery Time Picker
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: timeController,
                                decoration: InputDecoration(
                                  labelText: selectedTime.isEmpty ? 'Select Delivery Time' : selectedTime,  // Show time or default message
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Payment method selection
                          Text(
                            'Scan GCASH QR Code',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (deliveryOption == 'Delivery')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Image.asset(
                                        'assets/images/gcash.jpg',
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _pickImage();
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFEFCA6C),
                                      ),
                                      child: const Text('Upload Payment', style: TextStyle(fontSize: 12.5, color: Colors.black)),
                                    ),
                                    const SizedBox(height: 10),
                                    // Display the selected image
                                    if (_image != null)
                                      Image.file(
                                        _image!,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              String fullName = fullNameController.text.trim();
                              String phoneNumber = phoneController.text.trim();
                              String address = addressController.text.trim();
                              String selectedTime = timeController.text.trim();

                              if (fullName.isEmpty || phoneNumber.isEmpty || address.isEmpty || selectedTime.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Missing Information'),
                                    content: const Text('Please fill in all the fields before proceeding.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                List<String> selectedItems = [];
                                double totalAmount = 0;
                                quantities.forEach((name, quantity) {
                                  if (quantity > 0) {
                                    selectedItems.add(name);
                                    String price = '';

                                    // Check if the item belongs to Dishes, Bilao, or Desserts
                                    if (dishes.any((dish) => dish['name'] == name)) {
                                      price = dishes.firstWhere((dish) => dish['name'] == name)['price']!;
                                    } else if (bilao.any((dish) => dish['name'] == name)) {
                                      price = bilao.firstWhere((dish) => dish['name'] == name)['price']!;
                                    } else if (desserts.any((dish) => dish['name'] == name)) {
                                      price = desserts.firstWhere((dish) => dish['name'] == name)['price']!;
                                    }

                                    // Update total amount
                                    totalAmount += double.parse(price.replaceAll('₱', '').replaceAll(',', '')) * quantity;
                                  }
                                });

                                // Create the order if items are selected
                                if (selectedItems.isNotEmpty) {
                                  final order = Order(
                                    orderId: _generateOrderId(),
                                    orderMethod: deliveryOption,
                                    orderPlaced: DateTime.now().toString(),
                                    amount: totalAmount,
                                    status: 'Pending',
                                    dishes: selectedItems,
                                    deliveryTime: selectedTime,
                                  );


                                  if (order.orderMethod == "Delivery") {
                                    startDeliveryTimer(order.orderId);
                                  }

                                  startFoodReadinessTimer(order.orderId);

                                  // Close the modal
                                  Navigator.pop(context);

                                  // Reset the quantities after placing the order
                                  setState(() {
                                    quantities.forEach((key, value) {
                                      quantities[key] = 0;  // Reset all items
                                    });
                                  });



                                  orders.add(order);
                                  _showOrderPlacedModal(context);

                                } else {
                                  _showCustomSnackBar('Please add items to your order.');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEFCA6C),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(500, 40),
                            ),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  String _generateOrderId() {
    final randomNumber = DateTime.now().millisecondsSinceEpoch % 100000;  // Generate a random number with max 5 digits
    return randomNumber.toString().padLeft(5, '0');  // Pad the number with leading zeros to ensure it's 5 digits
  }


  void _showOrderPlacedModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: Text('Order placed successfully!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the confirmation modal
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }



  void _showSummarySidebar(BuildContext context) {
    final orderedItems = quantities.entries.where((e) => e.value > 0).toList();

    _resetAnimation();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Align(
              alignment: Alignment.centerRight,
              child: SlideTransition(
                position: _slideAnimation,
                child: FractionallySizedBox(
                  alignment: Alignment.centerRight,
                  widthFactor: 0.8,
                  child: Material(
                    color: Colors.white,
                    elevation: 13,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(left: Radius
                          .circular(10)),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Summary', style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(height: 12),
                            if (orderedItems.isEmpty)
                              const Text('No items selected.'),
                            if (orderedItems.isNotEmpty)
                              Expanded(
                                child: ListView(
                                  children: orderedItems.map((item) {
                                    final itemName = item.key;
                                    final itemQuantity = item.value;
                                    final itemPrice = _getItemPrice(itemName);
                                    final totalItemPrice = itemPrice *
                                        itemQuantity;

                                    return ListTile(
                                      title: Text(
                                        itemName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5F6D69)),
                                      ),
                                      subtitle: Text(
                                        '₱${itemPrice.toStringAsFixed(2)} each',
                                        style: const TextStyle(fontSize: 13,
                                            color: Color(0xFF5F6D69)),
                                      ),
                                      trailing: Text(
                                        'x$itemQuantity - ₱${totalItemPrice
                                            .toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF5F6D69)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            // Total price section
                            if (orderedItems.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Column(
                                  children: [
                                    Text('Total price',
                                      style: const TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '₱${orderedItems.fold(0.0, (total, item) {
                                        double price = 0.0;

                                        final dish = dishes.firstWhere(
                                              (dish) =>
                                          dish['name'] == item.key,
                                          orElse: () => {},
                                        );
                                        if (dish.isNotEmpty) {
                                          price = double.tryParse(
                                              dish['price']?.substring(1) ??
                                                  '0') ?? 0.0;
                                        } else {
                                          final bilaoItem = bilao.firstWhere(
                                                (bilao) =>
                                            bilao['name'] == item.key,
                                            orElse: () => {},
                                          );
                                          if (bilaoItem.isNotEmpty) {
                                            price =
                                                double.tryParse(
                                                    bilaoItem['price']
                                                        ?.substring(1) ??
                                                        '0') ?? 0.0;
                                          } else {
                                            final dessertItem = desserts.firstWhere(
                                                  (bilao) =>
                                              bilao['name'] == item.key,
                                              orElse: () => {},
                                            );
                                            if (dessertItem.isNotEmpty) {
                                              price =
                                                  double.tryParse(
                                                      dessertItem['price']
                                                          ?.substring(1) ??
                                                          '0') ?? 0.0;
                                            }
                                          }
                                        }
                                        return total + (price * item.value);
                                      }).toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 20,)
                                  ],
                                ),

                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (deliveryOption == 'Delivery') {
                                          deliveryOption = 'Pick Up';
                                        } else
                                        if (deliveryOption == 'Pick Up') {
                                          deliveryOption = 'Reservation';
                                        } else {
                                          deliveryOption = 'Delivery';
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEFCA6C),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: const Size.fromHeight(55),
                                    ),
                                    child: Text(
                                      deliveryOption, style: TextStyle(
                                      fontSize: deliveryOption == 'Reservation'
                                          ? 11.7
                                          : 14,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                ),

                                SizedBox(width: 13,),

                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _checkout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEFCA6C),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: const Size.fromHeight(55),
                                    ),
                                    child: const Text(
                                      'Checkout', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                )

                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  double _getItemPrice(String itemName) {
    double price = 0.0;
    final dish = dishes.firstWhere((dish) => dish['name'] == itemName,
        orElse: () => {});
    if (dish.isNotEmpty) {
      price = double.tryParse(dish['price']?.substring(1) ?? '0') ?? 0.0;
    } else {
      final bilaoItem = bilao.firstWhere((bilao) => bilao['name'] == itemName,
          orElse: () => {});
      if (bilaoItem.isNotEmpty) {
        price = double.tryParse(bilaoItem['price']?.substring(1) ?? '0') ?? 0.0;
      } else {
        final bilaoItem = desserts.firstWhere((bilao) =>
        bilao['name'] == itemName,
            orElse: () => {});
        if (bilaoItem.isNotEmpty) {
          price =
              double.tryParse(bilaoItem['price']?.substring(1) ?? '0') ?? 0.0;
        } else {
          final dessertItem = desserts.firstWhere((bilao) =>
          bilao['name'] == itemName,
              orElse: () => {});
          if (dessertItem.isNotEmpty) {
            price =
                double.tryParse(dessertItem['price']?.substring(1) ?? '0') ?? 0.0;
          }
        }
      }
    }
    return price;
  }
}

Widget _drawerItem(BuildContext context, String title, String route, IconData icon) {
  return ListTile(
    leading: FaIcon(icon, color: Colors.black, size: 23),
    title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
    onTap: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, route);
    },
  );
}

void _showLogoutModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFEFCA6C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.black),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Logout'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ),
  );
}


class OffsetFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double xOffset;
  final double yOffset;

  const OffsetFloatingActionButtonLocation({
    this.xOffset = 0,
    this.yOffset = 0,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final fabSize = geometry.floatingActionButtonSize;
    final scaffoldSize = geometry.scaffoldSize;

    double x = scaffoldSize.width - fabSize.width - 16 + xOffset;
    double y = scaffoldSize.height - fabSize.height - 16 + yOffset;

    return Offset(x, y);
  }
}