import 'package:chat/common/error_screen.dart';
import 'package:chat/common/loading_indicator.dart';
import 'package:chat/controller/chat_controller.dart';
import 'package:chat/model/message.dart';
import 'package:chat/widgets/my_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'sender_message_card.dart';

class ChatList extends ConsumerWidget {
  final String receiverUid;
  ChatList({Key? key, required this.receiverUid}) : super(key: key);
  ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (messageController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        messageController.jumpTo(messageController.position.maxScrollExtent);
      });
    }
    return StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerProvider).chatStream(receiverUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return ErrorScreen(
              error: snapshot.error.toString(),
            );
          } else {
            return ListView.builder(
              controller: messageController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data?[index];
                var date = DateTime.fromMillisecondsSinceEpoch(
                    messageData!.timeSent.millisecondsSinceEpoch);
                if (!messageData.isSeen &&
                    messageData.receiverUid ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).setChatMessageSeen(
                        context,
                        receiverUid,
                        messageData.messageId,
                      );
                }
                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: DateFormat('h:mm a').format(date),
                    userName: messageData.repliedTo,
                    isSeen: messageData.isSeen,
                  );
                }
                return SenderMessageCard(
                  message: messageData.text,
                  date: DateFormat('h:mm a').format(date),
                  userName: messageData.repliedTo,
                );
              },
            );
          }
        });
  }
}
