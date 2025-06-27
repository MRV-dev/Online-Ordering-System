import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Food Recommendations'),
        ),
        body: Column(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'You Might Also Like',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FoodItem(
                          image: 'assets/Dessert.png',
                          title: 'Grahams',
                        ),
                        FoodItem(
                          image: 'assets/Pancit_Canton_Bihon_Guisado.png',
                          title: 'Bihon',
                        ),
                        FoodItem(
                          image: 'assets/sweet_and_spicy.png',
                          title: 'Sweet & Spicy',
                        ),
                        FoodItem(
                          image: 'assets/Spaghetti.png',
                          title: 'Spaghetti',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spacer to push the footer to the bottom
            Expanded(child: SizedBox.shrink()),

            // Footer Section
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                children: [
                  // Footer menu links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 300,
                        child: Column(
                          children: [
                            Text('Purok 2, Puting Bato East Calaca City Batangas'),
                            Text('El Callejon Lomi Hauz'),
                          ],
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 30), // Corrected for height space

                  // Email and phone number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.email),
                          SizedBox(height: 8), // Correct spacing between the icon and text
                          Text('elcallejonlomihauz@gmail.com'),
                          SizedBox(height: 16), // Spacing between the email and phone number
                          Icon(Icons.phone),
                          SizedBox(height: 8), // Correct spacing between the icon and text
                          Text('09123456789'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Corrected for height space
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodItem extends StatelessWidget {
  final String image;
  final String title;

  FoodItem({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Image.asset(image, width: 150, height: 150, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Order Now'),
          ),
        ],
      ),
    );
  }
}
