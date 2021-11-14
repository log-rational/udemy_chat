// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Provider
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

// Widgets
import '../widgets/custom_list_view_tiles.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late ChatPageProvider _chatPageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatPageProvider>(create: (_) {
        return ChatPageProvider(_auth);
      })
    ], child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(
      builder: ((BuildContext _context) {
        _chatPageProvider = _context.watch<ChatPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.97,
          width: _deviceWidth * 0.98,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _deviceHeight * 0.1,
              ),
              _chatList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _chatList() {
    return Expanded(
      child: _chatTile(),
    );
  }

  Widget _chatTile() {
    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.1,
      title: "Umesh Rai",
      subtitle: "hello world!",
      imagePath: "https://i.pravatar.cc/300",
      isActive: true,
      isActivity: false,
      onTap: () {
        debugPrint("hello world!");
      },
    );
  }
}
