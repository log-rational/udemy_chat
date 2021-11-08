import 'dart:core';
import 'package:intl/intl.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  final DateTime lastActive;
  ChatUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.imageURL,
      required this.lastActive}) {}

  factory ChatUser.fromJSON(_json) {
    return ChatUser(
        uid: _json['uid'],
        name: _json["name"],
        email: _json['email'],
        imageURL: _json['image'],
        lastActive: _json['last_active'].toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'last_active': lastActive,
      'image': imageURL
    };
  }

  String getlastActive() {
    return DateFormat("dd MMM yyyy").format(lastActive);
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
