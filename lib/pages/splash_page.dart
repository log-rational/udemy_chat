import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({
    Key? key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Udemy Chat",
      theme: ThemeData(
          backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(35, 36, 49, 1.0)),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        // colorFilter: ColorFilter.linearToSrgbGamma(),
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/1ukdiv.png"))),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  "Force Tracker".toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 22),
                ),
              ),
              const Text(
                "Beta Version 0.1",
                style: TextStyle(color: Colors.white, fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
