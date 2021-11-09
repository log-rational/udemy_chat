// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:udemy_chat/models/chat_user.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;
  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((_user) {
      print("USER::$_user");
      if (_user != null) {
        _databaseService.updateUserLastSeenTime(_user.uid);
        _navigationService.removeAndNavigateToRoute('/home');

        _databaseService.getUser(_user.uid).then((_snapshot) {
          if (_snapshot.data() == null) {
            return;
          }
          Map<String, dynamic> _userData =
              _snapshot.data() as Map<String, dynamic>;

          // print((_userData['last_active'].toDate().runtimeType));
          user = ChatUser.fromJSON({
            "uid": _user.uid,
            "name": _userData['name'],
            "email": _userData['email'],
            "image": _userData['image'],
            "last_active": _userData['last_active']
          });
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
        print("Logged out");
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
    } on FirebaseAuthException {
      print("Error loggin user.");
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      var userRecord = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      return userRecord.user!.uid;
    } catch (e) {
      print(e);
    }
  }
}
