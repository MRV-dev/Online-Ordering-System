import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
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
            _drawerItem(context, 'Contact Us', '/contactus', FontAwesomeIcons.phone),
            _drawerItem(context, 'Notifications', '/notifications', FontAwesomeIcons.bell),
            _drawerItem(context, 'Account', '/profile', FontAwesomeIcons.user),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                color: Color(0xFFF1F9F5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Satisfy your cravings',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Feel the warmth.\nTaste the flavor.\nLomi at your doorstep.',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/OrderNow');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD766),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 320,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.75),
                        children: [
                          _buildPageCard('assets/images/maja.jpg', 'Maja Blanca is a creamy Filipino dessert made from coconut milk, cornstarch, and sweet corn.'),
                          _buildPageCard('assets/images/lomi.jpg', 'Lomi is a thick, savory noodle soup made with egg noodles, rich broth, and hearty toppings.'),
                          _buildPageCard('assets/images/chami.jpg', 'Chami Lomi is a thick noodle dish made with saut\u00e9ed egg noodles, rich sauce, and savory toppings.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Our Services Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our Services', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _serviceCard(Icons.delivery_dining, 'Fast Delivery'),
                        _serviceCard(Icons.restaurant_menu, 'Fresh Menu'),
                        _serviceCard(Icons.star, 'Top Rated'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Our Best Selling Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                color: Color(0xFFFFF8E1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our Best Selling', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FoodItem(image: 'assets/images/lomi.jpg', title: 'Special Lomi'),
                          FoodItem(image: 'assets/images/chami.jpg', title: 'Chami Lomi'),
                          FoodItem(image: 'assets/images/maja.jpg', title: 'Maja Blanca'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // You Might Also Like Section
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('You Might Also Like', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FoodItem(image: 'assets/images/Dessert.png', title: 'Grahams'),
                          FoodItem(image: 'assets/images/Pancit_Canton_Bihon_Guisado.png', title: 'Bihon'),
                          FoodItem(image: 'assets/images/sweet_and_spicy.png', title: 'Sweet & Spicy'),
                          FoodItem(image: 'assets/images/Spaghetti.png', title: 'Spaghetti'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Footer Section
              Container(
                padding: EdgeInsets.only(left: 25, top: 18, right: 25, bottom: 14),
                color: Color(0xFF131615),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text('CONTACT US', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Purok 2,', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                              Text('Puting Bato East', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                              Text('Calaca City Batangas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('PHONE NO.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                            Text('09123456789', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Text('FOLLOW US', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: Icon(FontAwesomeIcons.facebook, color: Colors.white), onPressed: () {}),
                            IconButton(icon: Icon(FontAwesomeIcons.instagram, color: Colors.white), onPressed: () {}),
                            IconButton(icon: Icon(FontAwesomeIcons.twitter, color: Colors.white), onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageCard(String image, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 120),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontFamily: 'Georgia')),
            ),
          ],
        ),
      ),
    );
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
          TextButton(child: const Text('Logout'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget _serviceCard(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(radius: 30, backgroundColor: Color(0xFFFFD766), child: Icon(icon, size: 30, color: Colors.black)),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class FoodItem extends StatelessWidget {
  final String image;
  final String title;

  const FoodItem({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Image.asset(image, width: 110, height: 110, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: Text('Order Now')),
        ],
      ),
    );
  }
}
