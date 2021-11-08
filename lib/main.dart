import 'package:flutter/material.dart';
// Packages
import 'package:firebase_analytics/firebase_analytics.dart';

// Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';

// Services
import './services/navigation_service.dart';

void main() {
  runApp(SplashPage(onInitializationComplete: () {
    runApp(
      MainApp(),
    );
  }));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/login",
      navigatorKey: NavigationService.navigatorKey,
      routes: {'/login': (BuildContext _ctx) => LoginPage()},
      title: "Force Tracker",
      theme: ThemeData(
          backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(30, 29, 37, 1.0))),
    );
  }
}
