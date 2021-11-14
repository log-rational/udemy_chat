// Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matcher/matcher.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/top_bar.dart';

// Models
import '../models/chat.dart';
import '../models/chat_message.dart';
// Services
// Providers
import '../providers/chat_page_provider.dart';
import '../providers/authentication_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;

  late ChatPageProvider _chatPageProvider;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    // _messageListViewController
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(create: (_) {
          return ChatPageProvider(
              widget.chat.uid, _auth, _messageListViewController);
        }),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _chatPageProvider = _context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * .03,
                  vertical: _deviceHeight * .02),
              height: _deviceHeight * 0.98,
              width: _deviceWidth * .97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopBar(
                    this.widget.chat.title(),
                    fontSize: 16,
                    primaryAction: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
