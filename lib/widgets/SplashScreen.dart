import 'dart:async';
import 'package:flutter/material.dart';
import 'Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/Icon_Tecnm.png', 
            fit: BoxFit.cover,
            height: height * 0.9,
            width: width * 0.5,
            ),
            SizedBox(height: height * 0.04),
            const CircularProgressIndicator(
              color: Color( 0xff1b3a6b),
              strokeWidth: 5,
            ),
          ],
        )
      ),
    );
  }
}
