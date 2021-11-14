import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  late String _barTitle;
  late Widget? primaryAction;
  late Widget? secondaryAction;
  late double fontSize;

  late double _deviceHeight;
  late double _deviceWidth;

  TopBar(String bar_title,
      {this.primaryAction, this.secondaryAction, this.fontSize = 20}) {
    _barTitle = bar_title;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI() {
    return Container(
      height: _deviceHeight * 0.15,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w500),
    );
  }
}
