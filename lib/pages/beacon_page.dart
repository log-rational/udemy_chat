// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/beacon_state_provider.dart';

// Provider
import '../providers/authentication_provider.dart';

class BeaconPage extends StatefulWidget {
  const BeaconPage({Key? key}) : super(key: key);

  @override
  _BeaconPageState createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late BeaconProvider _beacon;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    _beacon = Provider.of<BeaconProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeight * 0.02,
      ),
      height: _deviceHeight * 0.97,
      width: _deviceWidth * 0.98,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(children: [
              SizedBox(
                height: _deviceHeight * 0.1,
              ),
              AnimatedCircle(beacon: _beacon),
              SizedBox(
                height: _deviceHeight * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: _beacon.emitting ? Colors.red : Colors.blue),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _deviceWidth * 0.02,
                      vertical: _deviceHeight * 0.02),
                  child: Text(
                    _beacon.emitting ? "Turn Off" : "Turn On",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  _beacon.toggle();
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class AnimatedCircle extends StatefulWidget {
  const AnimatedCircle({
    Key? key,
    required BeaconProvider beacon,
  })  : _beacon = beacon,
        super(key: key);

  final BeaconProvider _beacon;

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 100,
      width: 100,
      child: Icon(
        widget._beacon.emitting
            ? Icons.location_on_sharp
            : Icons.location_off_sharp,
        color: const Color.fromARGB(200, 237, 125, 58),
        size: 40,
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromRGBO(36, 35, 49, 1.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(130, 237, 125, 58),
              blurRadius: widget._beacon.emitting ? _animation.value : 1,
              spreadRadius: widget._beacon.emitting ? _animation.value : 1,
            ),
          ]),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
