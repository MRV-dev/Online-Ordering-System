import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_ordering_system/pages/password.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'reservations.dart';
import 'order_history.dart';
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
      backgroundColor: Color(0xFFFFFBEB),
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
        backgroundColor: Color(0xFFEFCA6C),
        width: 200,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            const SizedBox(height: 85),
            _drawerItem(context, 'Home', '/landingpage', FontAwesomeIcons.house),
            _drawerItem(context, 'Order Now', '/OrderNow', FontAwesomeIcons.cartPlus),
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
                _buildToggleButton('Reservations', 3),
                _buildToggleButton('Order History', 4),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
                ReservationsPage(),
                OrderHistory(orders: [], pickUpOrders: [],),
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
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