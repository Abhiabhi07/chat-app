import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverUid;
  final String text;
  final MessageEnum type;
  final Timestamp timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.receiverUid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  // Converts a Message instance into a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': receiverUid,
      'text': text,
      'type': type.type,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMesaageType': repliedMessageType.type
    };
  }

  // Creates a Message instance from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverUid: map['recieverId'],
      text: map['text'],
      type: (map['type'] as String).toEnum(),
      timeSent: map['timeSent'],
      messageId: map['messageId'],
      isSeen: map['isSeen'],
      repliedMessage: map['repliedMessage'],
      repliedTo: map['repliedTo'],
      repliedMessageType: (map['repliedMesaageType'] as String).toEnum(),
    );
  }
}
