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
                    widget.chat.title(),
                    fontSize: 16,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _chatPageProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _chatPageProvider.goBack();
                      },
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_chatPageProvider.messages != null) {
      if (_chatPageProvider.messages!.isEmpty) {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first one to say hi!",
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
              controller: _messageListViewController,
              itemCount: _chatPageProvider.messages!.length,
              itemBuilder: (BuildContext _context, int _index) {
                ChatMessage _message = _chatPageProvider.messages![_index];
                bool _isOwnMessage = _message.senderID == _auth.user.uid;
                return Container(
                    child: CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * .8,
                  message: _message,
                  isOwnMessage: _isOwnMessage,
                  sender: widget.chat.members
                      .where((d) => d.uid == _message.senderID)
                      .first,
                ));
              }),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
          color: Color.fromRGBO(30, 29, 37, 1),
          borderRadius: BorderRadius.circular(100)),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton()
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (_value) {
          _chatPageProvider.message = _value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "type your message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _chatPageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
        icon: Icon(
          Icons.send,
          size: _size / 1.5,
        ),
        color: Colors.white,
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1),
        onPressed: () {
          _chatPageProvider.sendImageMessage();
        },
        child: Icon(
          Icons.camera_enhance,
          size: _size / 1.5,
        ),
      ),
    );
  }
}
