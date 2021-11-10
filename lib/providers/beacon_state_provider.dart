import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

import 'package:udemy_chat/services/database_service.dart';

class BeaconProvider with ChangeNotifier {
  late final FirebaseAuth _auth;
  late final DatabaseService _databaseService;
  late Map<String, bool> _emitting;
  late Timer _timer;
  late String _uid;

  BeaconProvider() {
    _auth = FirebaseAuth.instance;
    _databaseService = GetIt.instance.get<DatabaseService>();

    _emitting = {
      "state": true,
    };
    _timer = initTimer();
  }

  bool get emitting {
    return _emitting['state']!;
  }

  void turnOff() {
    _emitting['state'] = false;
    initLocationEmmit();
    notifyListeners();
  }

  void turnOn() {
    initLocationEmmit();
    _emitting['state'] = true;
    notifyListeners();
  }

  void toggle() {
    _emitting['state'] = !emitting;
    initLocationEmmit();
    notifyListeners();
  }

  void initLocationEmmit() {
    if (emitting) {
      if (!_timer.isActive) {
        _timer = initTimer();
      }
    } else {
      _timer.cancel();
    }
  }

  Timer initTimer() {
    return Timer.periodic(const Duration(seconds: 2), (timer) {
      _uid = _auth.currentUser!.uid;
      _databaseService.updateLocation(
          _uid, [Random().nextDouble() * 100, Random().nextDouble() * 100]);
      _databaseService.updateUserLastSeenTime(_uid);

      debugPrint(timer.tick.toString());
    });
  }

  void cancelTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}
