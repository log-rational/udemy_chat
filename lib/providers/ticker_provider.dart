import 'package:flutter/material.dart';

class CustomTickerProvider extends State
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        ChangeNotifier {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationController.repeat(
      reverse: true,
      max: 1,
    );
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Animation get animation {
    return _animation;
  }
}
