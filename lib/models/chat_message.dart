import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_chat/services/database_service.dart';

enum MessageType { TEXT, IMAGE, UNKNOWN }

class ChatMessage {
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.senderID,
    required this.sentTime,
    required this.content,
    required this.type,
  });

  factory ChatMessage.fromJSON(Map<String, dynamic> _json) {
    MessageType _messageType;
    switch (_json['type']) {
      case 'text':
        _messageType = MessageType.TEXT;
        break;
      case 'image':
        _messageType = MessageType.IMAGE;
        break;
      default:
        _messageType = MessageType.UNKNOWN;
    }

    return ChatMessage(
        senderID: _json['sender_id'],
        sentTime: _json['sent_time'].toDate(),
        content: _json['content'],
        type: _messageType);
  }

  Map<String, dynamic> toJSON() {
    String _messageType;
    switch (type) {
      case MessageType.TEXT:
        _messageType = 'text';
        break;
      case MessageType.IMAGE:
        _messageType = 'image';
        break;
      default:
        _messageType = 'unknown';
    }
    return {
      'sender_id': senderID,
      'sent_time': Timestamp.fromDate(sentTime),
      'content': content,
      'type': _messageType
    };
  }
}
