import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/widgets/bottom_chat_field.dart';
import 'package:chat/widgets/chat_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class ChatScreen extends ConsumerWidget {
  static const routeName = '/chat-screen';
  final String name;
  final String bio;
  final String uid;
  final String profilePic;

  // final bool isGroupChat;
  ChatScreen({
    required this.name,
    required this.bio,
    required this.uid,
    required this.profilePic,

    // required this.isGroupChat,
    super.key,
  });

  var isOnline = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        leadingWidth: 20.0,
        title: StreamBuilder(
          stream: ref.read(authControllerProvider).getUserDataById(uid),
          builder: (context, snapshot) {
            // isOnline = snapshot.data!.isOnline;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(profilePic),
              ),
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                bio,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
        actions: [
          if (isOnline)
            const Padding(
              padding: EdgeInsets.only(right: 14.0),
              child: Icon(
                Icons.circle,
                size: 12,
              ),
            ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.phone,
              ))
        ],
      ),
      body: ChatList(
        receiverUid: uid,
      ),
      // SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [

      //       BottomChatField(),
      //     ],
      //   ),
      // ),
      //  ListView(
      //   // mainAxisAlignment: MainAxisAlignment.end,
      //   children: <Widget>[

      //     // Positioned(bottom: 0.0, child: BottomChatField()),
      //   ],
      // ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
            // height: 45,
            width: MediaQuery.of(context).size.width,
            // color: Colors.white,
            child: BottomChatField(
              receiverUid: uid,
              isGroupChat: false,
            )),
      ),
    );
  }
}
