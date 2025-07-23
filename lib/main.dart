import 'package:flutter/material.dart';
import 'package:online_ordering_system/pages/loading.dart';
import 'package:online_ordering_system/pages/profile.dart';
import 'auth/signup.dart';
import 'pages/landingPage.dart';
import 'pages/ordernow.dart';
import 'pages/contactus.dart';
import 'pages/notifications.dart';
import 'package:online_ordering_system/auth/login.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LomiHub',
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/landingpage': (context) => const Landingpage(),
        '/contactus': (context) => const ContactUs(),
        '/OrderNow': (context)   => const Ordernow(),
        '/notifications': (context) => const Notifications(),
        '/profile': (context) => Account(),
        '/loading': (context) => const LoadingScreen(),
      },
    );
  }
}
