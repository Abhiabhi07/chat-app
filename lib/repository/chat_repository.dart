import 'package:chat/common/error_screen.dart';
import 'package:chat/enums/message_enum.dart';
import 'package:chat/model/chat_contact.dart';
import 'package:chat/model/message.dart';
import 'package:chat/model/message_reply_provider.dart';
import 'package:chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  var messageId = const Uuid().v1();

  void _saveDataContactsSubCollection(
    UserModel sendUserData,
    UserModel receiverUserData,
    String text,
    Timestamp timeSent,
    String receiverUid,
    bool isGroupChat,
  ) async {
    var receiverChatContact = ChatContact(
      name: sendUserData.name,
      bio: sendUserData.bio,
      profilePic: sendUserData.profilePic,
      contactId: sendUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(receiverUid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );

    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      bio: receiverUserData.bio,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUid,
    required String text,
    required Timestamp timeSent,
    required String messageId,
    required String userName,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required String senderUserName,
    required String receiverUserName,
    required MessageEnum repliedMessageType,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverUid: receiverUid,
      text: text,
      type: messageEnum,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : receiverUserName,
      repliedMessageType: repliedMessageType,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(receiverUid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUid,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = Timestamp.now();

      UserModel? receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUid).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      print('11122111');

      _saveDataContactsSubCollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUid,
        isGroupChat,
      );

      _saveMessageToMessageSubCollection(
        receiverUid: receiverUid,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        messageEnum: MessageEnum.text,
        messageReply: messageReply,
        senderUserName: senderUser.name,
        receiverUserName: receiverUserData.name,
        repliedMessageType: MessageEnum.text,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showErrorBtmSheet(context, e.toString());
    }
  }

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(
          document.data(),
        );

        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            bio: user.bio,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }

      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return messages;
    });
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUid,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });

      await firestore
          .collection('users')
          .doc(receiverUid)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      showErrorBtmSheet(context, e.toString());
    }
  }
}
