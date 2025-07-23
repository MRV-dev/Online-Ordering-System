import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/landingpage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7D6),
      body: Center(
        child: Stack(
          alignment: Alignment.center, // Align the content in the center
          children: [
            // The Loading Spinner
            SpinKitThreeBounce(
              color: const Color(0xFFEFCA6C),
              size: 50.0,
            ),

            // Positioned(
            //   top: 300,
            //   child: Image.asset(
            //     'assets/images/logo.jpg',
            //     height: 80,
            //     width: 80,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
