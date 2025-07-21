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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section with PageView
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                color: const Color(0xFFF1F9F5),
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
                          _buildPageCard(
                            'assets/images/lomi.jpg',
                            'Lomi is a thick, savory noodle soup made with egg noodles, rich broth, and hearty toppings.',
                          ),
                          _buildPageCard(
                              'assets/images/sweet_and_spicy.png',
                              'Sweet & Spicy is a stir-fried noodle dish with a chewy texture, flavored with a blend of sweet and spicy sauce.'
                          ),
                          _buildPageCard(
                              'assets/images/plain.png',
                              'Plain Pancit is a traditional Filipino noodle dish stir-fried with vegetables and light seasoning, perfect for any occasion.'
                          ),
                          _buildPageCard(
                              'assets/images/bihon.png',
                              'Bihon is a Filipino noodle dish made with thin rice noodles sautéed with vegetables, meat, and savory sauce.'
                          ),
                          _buildPageCard(
                              'assets/images/tapsilog.png',
                              'Tapsilog is a popular Filipino breakfast meal made with tapa (marinated beef), garlic fried rice, and sunny-side-up egg.'
                          ),
                          _buildPageCard(
                              'assets/images/hotsilog.png',
                              'Hotsilog is a quick Filipino meal combining hotdog, garlic fried rice, and a fried egg.'
                          ),
                          _buildPageCard(
                              'assets/images/siomaisilog.png',
                              'Siomaisilog pairs siomai (steamed dumplings) with garlic fried rice and egg for a savory Filipino combo.'
                          ),
                          _buildPageCard(
                              'assets/images/siomai-rice.png',
                              'Siomai Rice is a filling meal of steamed dumplings served over seasoned rice, often with soy sauce and chili garlic.'
                          ),
                          _buildPageCard(
                              'assets/images/Pancit_bilao.png',
                              'Pancit Bilao is a festive noodle platter typically served on a bilao tray, perfect for sharing at gatherings.'
                          ),
                          _buildPageCard(
                              'assets/images/Spaghetti_bilao.png',
                              'Spaghetti Bilao features sweet-style Filipino spaghetti topped with cheese, served in a tray for parties.'
                          ),
                          _buildPageCard(
                              'assets/images/palabok_bilao.png',
                              'Palabok Bilao is a rich noodle platter with thick sauce, shrimp, egg, and chicharon toppings, served on a bilao.'
                          ),
                          _buildPageCard(
                              'assets/images/chami_bilao.png',
                              'Chami Bilao offers a saucy and savory noodle dish served on a large tray, ideal for group feasts.'
                          ),
                          _buildPageCard(
                              'assets/images/graham.png',
                              'Graham is a chilled layered dessert made with graham crackers, sweetened cream, and fruit like mango or banana.'
                          ),
                          _buildPageCard(
                              'assets/images/leche-flan.png',
                              'Leche Flan is a smooth, creamy caramel custard made with eggs, milk, and sugar.'
                          ),
                          _buildPageCard(
                              'assets/images/graham-bar.png',
                              'Graham Bar is a bite-sized version of graham dessert, layered with cream and crushed graham for a sweet treat.'
                          ),
                          _buildPageCard(
                            'assets/images/maja.jpg',
                            'Maja Blanca is a creamy Filipino dessert made from coconut milk, cornstarch, and sweet corn.',
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                color: const Color(0xFFF3D9B1),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "THIS IS WHAT WE DO",
                      style: TextStyle(fontSize: 14, letterSpacing: 1.5),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "OUR SERVICES",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ServiceCard(
                      icon: Icons.local_shipping,
                      title: "Delivery",
                      description:
                      "Our delivery service offers a convenient way to receive your items directly at your doorstep. We ensure fast, reliable, and contactless delivery within the designated service area. Simply place your order online or by phone, and we’ll handle the rest.",
                    ),
                    SizedBox(height: 20),
                    ServiceCard(
                      icon: Icons.shopping_bag,
                      title: "Pickup",
                      description:
                      "With our pickup service, you can place your order in advance and pickup at your convenience. This option is perfect for those who prefer to save time and avoid waiting in lines. Just choose your pickup time, and your order will be ready when you arrive.",
                    ),
                    SizedBox(height: 20),
                    ServiceCard(
                      icon: Icons.event_available,
                      title: "Reservation",
                      description:
                      "Our reservation service allows you to secure a spot in advance. Make your reservation online, and enjoy priority access and guaranteed availability without the hassle.",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Best Selling Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Our Best Selling',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: const [
                        BestSellingCard(
                          title: 'Best Selling Dishes',
                          itemName: 'Lomi',
                          imageUrl: 'assets/images/lomi.jpg',
                          bgColor: Color(0xFFCFF4F0),
                        ),
                        BestSellingCard(
                          title: 'Best Selling Bilao',
                          itemName: 'Palabok',
                          imageUrl: 'assets/images/palabok_bilao.png',
                          bgColor: Color(0xFFF8D1DC),
                        ),
                        BestSellingCard(
                          title: 'Best Selling Desserts',
                          itemName: 'Leche Flan',
                          imageUrl: 'assets/images/leche-flan.png',
                          bgColor: Color(0xFFCFF3FC),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // You Might Also Like Section
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'You Might Also Like',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          FoodItem(image: 'assets/images/Dessert.png', title: 'Grahams'),
                          FoodItem(image: 'assets/images/Pancit_bilao.png', title: 'bihon'),
                          FoodItem(image: 'assets/images/sweet_and_spicy.png', title: 'Sweet & Spicy'),
                          FoodItem(image: 'assets/images/Spaghetti_bilao.png', title: 'Spaghetti'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Footer Section
              Container(
                padding: const EdgeInsets.only(left: 25, top: 18, right: 25, bottom: 14),
                color: const Color(0xFF131615),
                child: Column(
                  children: [
                    const Align(
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
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Purok 2,', style: TextStyle(color: Colors.white, fontSize: 13)),
                              Text('Puting Bato East', style: TextStyle(color: Colors.white, fontSize: 13)),
                              Text('Calaca City Batangas', style: TextStyle(color: Colors.white, fontSize: 13)),
                            ],
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('PHONE NO.', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                            Text('09123456789', style: TextStyle(color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const Text('FOLLOW US', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(FontAwesomeIcons.facebook, size: 30, color: Colors.white),
                            SizedBox(width: 10),
                            Icon(FontAwesomeIcons.instagram, size: 30, color: Colors.white),
                            SizedBox(width: 10),
                            Icon(FontAwesomeIcons.twitter, size: 30, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
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
                style: const TextStyle(fontSize: 15, fontFamily: 'Georgia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FoodItem widget
class FoodItem extends StatelessWidget {
  final String image;
  final String title;

  const FoodItem({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Image.asset(image, width: 110, height: 110, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () {}, child: const Text('Order Now')),
        ],
      ),
    );
  }
}

// ServiceCard widget
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE7E9D1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
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
            child: Icon(icon, size: 48, color: Colors.yellowAccent),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(description, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// BestSellingCard widget
class BestSellingCard extends StatelessWidget {
  final String title;
  final String itemName;
  final String imageUrl;
  final Color bgColor;

  const BestSellingCard({
    super.key,
    required this.title,
    required this.itemName,
    required this.imageUrl,
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
              Text(title, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.deepOrange)),
              Text(itemName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Text('Order Now', style: TextStyle(decoration: TextDecoration.underline, fontSize: 14)),
                  Icon(Icons.arrow_right_alt, size: 20),
                ],
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
        ],
      ),
    );
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
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog only
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