import 'package:flutter/material.dart';

class BeaconProvider with ChangeNotifier {
  late Map<String, bool> _emitting;

  BeaconProvider() {
    _emitting = {
      "state": true,
    };
  }

  bool get emitting {
    return _emitting['state']!;
  }

  void turnOff() {
    _emitting['state'] = false;
    notifyListeners();
  }

  void turnOn() {
    _emitting['state'] = true;
    notifyListeners();
  }

  void toggle() {
    _emitting['state'] = !emitting;
    notifyListeners();
  }
}
