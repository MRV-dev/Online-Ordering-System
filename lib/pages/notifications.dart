import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Notifications extends StatefulWidget {
  const Notifications ({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Map<String, dynamic>> _notifications = [];

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['read'] = true;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
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
            builder: (context) => IconButton(
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
            _drawerItem(context, 'Notifications', '/notifications', FontAwesomeIcons.bell),
            _drawerItem(context, 'Account', '/profile', FontAwesomeIcons.user),
            ListTile(
              leading: const Icon(FontAwesomeIcons.arrowRightFromBracket, color: Colors.black,),
              title: const Text('Logout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
              onTap: () {
                Navigator.pop(context);
                _showLogoutModal(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFFFFFBEB),  // Set your desired background color here
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notifications",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _notifButton("✔️ Mark all as Read", Colors.green, _markAllAsRead),
                const SizedBox(width: 8),
                _notifButton("🗑️ Clear All", Colors.red, _clearAll),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "No notifications available.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _notifButton(String label, Color borderColor, VoidCallback onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 14, color: borderColor),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String route, IconData icon) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.black, size: 23,),
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            ),
          ],
        ),
      ),
    );
  }
}
