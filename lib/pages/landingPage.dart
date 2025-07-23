import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            builder: (context) => IconButton(
              icon: const Icon(FontAwesomeIcons.bars, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ] : null,
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
              // Hero Section with text and water curvy background behind it
              Stack(
                children: [
                  ClipPath(
                    clipper: Wave(),
                    child: Container(
                      height: 320, // Adjust height for the curvy background
                      color: Color(0xFFFFFFFF), // Water color with some transparency
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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
                        const SizedBox(height: 46),
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          height: 320,
                          child: PageView(
                            controller: PageController(viewportFraction: 0.75),
                            children: [
                              _buildPageCard(
                                'assets/images/maja.jpg',
                                'Maja Blanca is a creamy Filipino dessert made from coconut milk, cornstarch, and sweet corn.',
                              ),
                              _buildPageCard(
                                'assets/images/lomi.jpg',
                                'Lomi is a thick, savory noodle soup made with egg noodles, rich broth, and hearty toppings.',
                              ),
                              _buildPageCard(
                                'assets/images/chami.jpg',
                                'Chami Lomi is a thick noodle dish made with sautéed egg noodles, rich sauce, and savory toppings.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              //You Might Like
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "THIS IS WHAT WE DO",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "OUR SERVICES",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const ServiceCard(
                      icon: FontAwesomeIcons.shippingFast,
                      title: "Delivery",
                      description:
                      "Our delivery service offers a convenient way to receive your items directly at your doorstep. We ensure fast, reliable, and contactless delivery within the designated service area. Simply place your order online or by phone, and we’ll handle the rest.",
                    ),
                    const SizedBox(height: 20),
                    const ServiceCard(
                      icon: FontAwesomeIcons.shoppingBag,
                      title: "Pickup",
                      description:
                      "With our pickup service, you can place your order in advance and pickup at your convenience. This option is perfect for those who prefer to save time and avoid waiting in lines. Just choose your pickup time, and your order will be ready when you arrive.",
                    ),
                    const SizedBox(height: 20),
                    const ServiceCard(
                      icon: FontAwesomeIcons.calendarAlt,
                      title: "Reservation",
                      description:
                      "Our reservation service allows you to secure a spot in advance. Make your reservation online, and enjoy priority access and guaranteed availability without the hassle.",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Our Best Selling',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: const [
                        BestSellingCard(
                          title: 'Best Selling Dishes',
                          itemName: 'Lomi',
                          image: 'assets/images/lomi.jpg',
                          bgColor: Color(0xFFCFF4F0),
                        ),
                        BestSellingCard(
                          title: 'Best Selling Bilao',
                          itemName: 'Palabok',
                          image: 'assets/images/palabok_bilao.png',
                          bgColor: Color(0xFFF8D1DC),
                        ),
                        BestSellingCard(
                          title: 'Best Selling Desserts',
                          itemName: 'Leche Flan',
                          image: 'assets/images/leche-flan.png',
                          bgColor: Color(0xFFCFF3FC),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              // "You Might Also Like" Section
              Container(
                padding: const EdgeInsets.all(16.0),
                height: 310,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Column(
                  children: [
                    Text(
                      'You Might Also Like',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // Horizontal list of food items
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


              // Footer Section
              Container(
                padding: EdgeInsets.only(left: 25, top: 18, right: 25, bottom: 14),
                color: Color(0xFF131615),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'CONTACT US',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
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
                              SizedBox(height: 3),
                              Text('Puting Bato East', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                              SizedBox(height: 3),
                              Text('Calaca City Batangas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('PHONE NO.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                                SizedBox(height: 1),
                                Text('09123456789', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 9),
                            Text('FOLLOW US', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            SizedBox(height: 7),
                            Row(
                              children: [
                                IconButton(icon: Icon(FontAwesomeIcons.facebook, size: 30, color: Colors.white), onPressed: () {}),
                                SizedBox(width: 7),
                                IconButton(icon: Icon(FontAwesomeIcons.instagram, size: 30, color: Colors.white), onPressed: () {}),
                                SizedBox(width: 7),
                                IconButton(icon: Icon(FontAwesomeIcons.twitter, size: 30, color: Colors.white), onPressed: () {}),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create PageView cards
  Widget _buildPageCard(String image, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 120),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Georgia',
                ),
              ),
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
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () {
              // Handle logout logic
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}


// ServiceCard Widget
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100), bottomLeft:
        Radius.circular(20), bottomRight: Radius.circular(20)),
        color: const Color(0xFFE7E9D1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 48, color: Colors.brown),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BestSellingCard extends StatelessWidget {
  final String title;
  final String itemName;
  final String image;
  final Color bgColor;

  const BestSellingCard({
    super.key,
    required this.title,
    required this.itemName,
    required this.image,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Order Now',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(FontAwesomeIcons.arrowRight, size: 15),
                ],
              ),
            ],
          ),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

// FoodItem Widget
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
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/OrderNow');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD766),
              foregroundColor: Colors.black,
            ),
            child: Text('Order Now'),
          ),
        ],
      ),
    );
  }
}


class Wave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start at the bottom left of the canvas
    path.lineTo(0, size.height);

    // First wave curve upwards
    var point1 = Offset(size.width * 0.25, size.height * 0.4);
    var point2 = Offset(size.width * 0.4, size.height * 0.45);

    path.quadraticBezierTo(point1.dx, point1.dy, point2.dx, point2.dy);

    // Second wave curve upwards
    var point3 = Offset(size.width * 0.5, size.height * 0.4);
    var point4 = Offset(size.width * 0.68, size.height * 0.54);

    path.quadraticBezierTo(point3.dx, point3.dy, point4.dx, point4.dy);

    // Third wave curve upwards
    var point5 = Offset(size.width * 0.85, size.height * 0.6);
    var point6 = Offset(size.width, size.height * 0.1);

    path.quadraticBezierTo(point5.dx, point5.dy, point6.dx, point6.dy);

    // Connect back to the top right
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
