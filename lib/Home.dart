import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFFFFFFF),
        body:SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Purok 2,',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Text('Puting Bato East',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    )
                                ),
                                SizedBox(height: 3,),
                                Text('Calaca City Batangas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    )
                                ),
                              ],
                            ),

                          ),


                          Container(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'PHONE NO.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        '09123456789',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              )

                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 9,),
                              Text('FOLLOW US', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                              SizedBox(height: 7,),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.facebook,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 7,),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.instagram,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(width: 7,),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.twitter,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
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
          Image.asset(image, width: 130, height: 130, fit: BoxFit.cover),
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