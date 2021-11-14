import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
// Packages
import 'package:timeago/timeago.dart' as timeago;

// models
import '../models/chat_message.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBubble(
      {required this.isOwnMessage,
      required this.message,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? const [
            Color.fromRGBO(0, 136, 249, 1.0),
            Color.fromRGBO(0, 82, 218, 1.0)
          ]
        : const [
            Color.fromRGBO(51, 49, 68, 1),
            Color.fromRGBO(51, 49, 68, 1),
          ];

    return Container(
      height: height + (message.content.length) / 20 * 6.0,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: _colorScheme,
              stops: const [0.30, 0.70],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            message.content,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const ImageMessageBubble(
      {required this.isOwnMessage,
      required this.message,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? const [
            Color.fromRGBO(0, 136, 249, 1.0),
            Color.fromRGBO(0, 82, 218, 1.0)
          ]
        : const [
            Color.fromRGBO(51, 49, 68, 1),
            Color.fromRGBO(51, 49, 68, 1),
          ];

    DecorationImage _image = DecorationImage(
        image: NetworkImage(message.content), fit: BoxFit.cover);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: _colorScheme,
              stops: const [0.30, 0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: height * 3,
            width: width * .75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), image: _image),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
