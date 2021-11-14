// packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:udemy_chat/models/chat.dart';
import 'package:udemy_chat/models/chat_message.dart';
import 'package:udemy_chat/models/chat_user.dart';

// Provider
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

// Services
import '../services/navigation_service.dart';

// Widgets
import '../widgets/custom_list_view_tiles.dart';

// Models
import '../models/chat.dart';

// Pages
import '../pages/chats_page.dart';
import 'chat.page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late ChatsPageProvider _chatsPageProvider;
  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatsPageProvider>(create: (_) {
        return ChatsPageProvider(_auth);
      })
    ], child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(
      builder: ((BuildContext _context) {
        _chatsPageProvider = _context.watch<ChatsPageProvider>();
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
                height: _deviceHeight * 0.02,
              ),
              _chatList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _chatList() {
    List<Chat>? _chats = _chatsPageProvider.chats;
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.isNotEmpty) {
            return ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext _context, int _index) {
                  return _chatTile(_chats[_index]);
                });
          } else {
            return const Center(
              child: Text("No Chats found."),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((d) => d.wasRecentlyActive());
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.1,
      title: _recepients.map((d) => d.name).join(", "),
      subtitle: _subtitleText,
      imagePath: "https://i.pravatar.cc/300",
      isActive: _isActive,
      isActivity: false,
      onTap: () {
        _navigation.navigateToPage(ChatPage(
          chat: _chat,
        ));
      },
    );
  }
}