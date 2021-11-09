import 'package:flutter/material.dart';
import 'dart:async';

class BeaconProvider with ChangeNotifier {
  late Map<String, bool> _emitting;
  late Timer _timer;

  BeaconProvider() {
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
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      // TODO implement coordinates push feature
      debugPrint(timer.tick.toString());
    });
  }
}
