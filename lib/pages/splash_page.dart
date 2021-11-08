// Packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/navigation_service.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';

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
  void initState() {
    super.initState();
    _setup().then((_) => widget.onInitializationComplete());
  }

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

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    print("${DateTime.now().toLocal()} :: Firebase Initialised!");
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    print("${DateTime.now().toLocal()} :: Navigation Service Registered!");
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    print("${DateTime.now().toLocal()} :: Media Service Registered!");

    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    print("${DateTime.now().toLocal()} :: Cloud Storage Service registered!");
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    print("${DateTime.now().toLocal()} :: Cloud Storage Service registered!");
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
    print("${DateTime.now().toLocal()} :: Database Service registered!");
  }
}
