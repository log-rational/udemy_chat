import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

import 'package:udemy_chat/services/database_service.dart';

class BeaconService {
  late final FirebaseAuth _auth;
  late final DatabaseService _databaseService;
  late Map<String, bool> _emitting;
  late Timer _timer;
  late String _uid;

  BeaconService() {
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
  }

  void turnOn() {
    _emitting['state'] = true;
    initLocationEmmit();
  }

  void toggle() {
    _emitting['state'] = !emitting;
    initLocationEmmit();
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
      if (_auth.currentUser == null) return;
      _uid = _auth.currentUser!.uid;
      // _databaseService.updateLocation(
      //     _uid, [Random().nextDouble() * 100, Random().nextDouble() * 100]);
      // _databaseService.updateUserLastSeenTime(_uid);

      print(timer.tick.toString());
    });
  }

  void cancelTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}
