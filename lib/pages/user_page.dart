// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:udemy_chat/providers/users_page_provider.dart';

// providers
import '../providers/authentication_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

// Models
import '../models/chat_user.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late double _deviceWidth;
  late double _deviceHeight;
  late AuthenticationProvider _auth;
  late UsersPageProvider _usersPageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _usersPageProvider = _context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.97,
          width: _deviceWidth * 0.98,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar("Users"),
              CustomTextField(
                onEditingComplete: (_value) {},
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
              ),
              _usersList(),
            ],
          ),
        );
      },
    );
  }

  Widget _usersList() {
    List<ChatUser>? _users = _usersPageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.isEmpty) {
            return const Center(
              child: Text("No users found"),
            );
          } else {
            return ListView.builder(
                itemCount: _users.length,
                itemBuilder: (BuildContext _context, int _index) {
                  return CustomListViewTile(
                    height: _deviceHeight * 0.1,
                    title: _users[_index].name,
                    subtitle: "Last Active: ${_users[_index].lastActive}",
                    imagePath: _users[_index].imageURL,
                    isActive: _users[_index].wasRecentlyActive(),
                    isSelected: _usersPageProvider.selectedUsers
                        .contains(_users[_index]),
                    onTap: () {
                      _usersPageProvider.updateSelectedUsers(_users[_index]);
                    },
                  );
                });
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }
}
