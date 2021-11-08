import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPress;
  const RoundedButton(
      {Key? key,
      required this.name,
      required this.height,
      required this.width,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.25),
          color: Color.fromRGBO(0, 82, 218, 1)),
      height: height,
      width: width,
      child: TextButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          name,
          style:
              const TextStyle(fontSize: 20, color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}
