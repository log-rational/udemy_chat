import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

// models
import '../models/chat.dart';
import '../models/chat_user.dart';

// Pages
import '../pages/chat.page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _db;
  late NavigationService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _seletedUsers;

  List<ChatUser> get selectedUsers {
    return _seletedUsers;
  }

  UsersPageProvider(this._auth) {
    _seletedUsers = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  void getUsers({String? name}) async {
    _seletedUsers = [];
    try {
      _db.getUsers(name: name).then((_snapshot) {
        users = _snapshot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data['uid'] = _doc.id;
          return ChatUser.fromJSON(_data);
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      print("Error getting users");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_seletedUsers.contains(_user)) {
      _seletedUsers.remove(_user);
    } else {
      _seletedUsers.add(_user);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
