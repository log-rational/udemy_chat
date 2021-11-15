import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:location/location.dart';

import 'package:udemy_chat/services/database_service.dart';

class BeaconService {
  late final FirebaseAuth _auth;
  late final DatabaseService _databaseService;
  late Map<String, bool> _emitting;
  late Timer _timer;
  late String _uid;

  late Location location = Location();
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

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

  Future<Map<String, dynamic>> getLocation() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    if (!_serviceEnabled) {
      return {'error': true};
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return {"error": true};
      }
    }
    _locationData = await location.getLocation();
    return {
      'lat': _locationData.latitude,
      'lng': _locationData.longitude,
      'heading': _locationData.heading,
    };
  }

  Timer initTimer() {
    return Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_auth.currentUser == null) return;
      _uid = _auth.currentUser!.uid;
      getLocation().then((_coords) {
        _databaseService.updateLocation(_uid, [_coords['lng'], _coords['lat']]);
        _databaseService.updateUserLastSeenTime(_uid);
      });
    });
  }

  void cancelTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}
