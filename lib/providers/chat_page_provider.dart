import 'dart:async';

import 'dart:ffi';

// Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

// Provider
import '../providers/authentication_provider.dart';

// Model
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;
  late StreamSubscription _messageStream;

  AuthenticationProvider _auth;
  late ScrollController _messagesListViewController;
  String _chatId;
  List<ChatMessage>? messages;

  String? _message;

  String get message {
    return message;
  }

  set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    listenToMessage();
  }

  void goBack() {
    _navigation.navigateBack();
  }

  void listenToMessage() {
    try {
      _messageStream = _db.streamMessageForChat(_chatId).listen((_snapshot) {
        List<ChatMessage> _messages = _snapshot.docs.map((_m) {
          Map<String, dynamic> _messageData = _m.data() as Map<String, dynamic>;
          return ChatMessage.fromJSON(_messageData);
        }).toList();
        messages = _messages;
        notifyListeners();
        WidgetsBinding.instance!.addPostFrameCallback(
          (timeStamp) {
            if (_messagesListViewController.hasClients) {
              _messagesListViewController
                  .jumpTo(_messagesListViewController.position.maxScrollExtent);
            }
          },
        );

        // Add Scroll to bottom
      });
    } catch (e) {
      print("Error getting messages");
    }
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
          content: _message!,
          type: MessageType.TEXT);
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _dwnloadURL = await _storage.saveChatImageToStorage(
            _chatId, _auth.user.uid, _file);
        ChatMessage _imageToSend = ChatMessage(
            senderID: _auth.user.uid,
            sentTime: DateTime.now(),
            content: _dwnloadURL!,
            type: MessageType.IMAGE);
        _db.addMessageToChat(_chatId, _imageToSend);
      }
    } catch (e) {
      print("Error sending image message");
    }
  }

  void deleteChat() {
    _navigation.navigateBack();
    _db.deleteChat(_chatId);
  }

  @override
  void dispose() {
    super.dispose();
    _messageStream.cancel();
  }
}
