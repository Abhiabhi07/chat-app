import 'package:chat/controller/auth_controller.dart';
import 'package:chat/model/chat_contact.dart';
import 'package:chat/model/message.dart';
import 'package:chat/model/message_reply_provider.dart';
import 'package:chat/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContact();
  }

  Stream<List<Message>> chatStream(String receiverUid) {
    return chatRepository.getChatStream(receiverUid);
  }

  void sendTextMessage(
      BuildContext context, String text, receiverUid, bool isGroupChat) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUid: receiverUid,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );

    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUid,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUid,
      messageId,
    );
  }
}
