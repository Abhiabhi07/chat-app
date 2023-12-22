import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/common/error_screen.dart';
import 'package:chat/common/loading_indicator.dart';
import 'package:chat/controller/auth_controller.dart';
import 'package:chat/controller/chat_controller.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/conatcts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ContactsScreen.routeName,
                );
              },
              icon: const Icon(CupertinoIcons.person_add)),
          IconButton(
              onPressed: () {
                ref.read(authControllerProvider).signOutUser();
              },
              icon: const Icon(
                Icons.logout_outlined,
              )),
        ],
      ),
      body: StreamBuilder(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatData = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 10.0, left: 10.0, top: 10.0),
                      child: ListTile(
                        tileColor: Colors.green,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ChatScreen.routeName, arguments: {
                            'name': chatData.name,
                            'uid': chatData.contactId,
                            'bio': chatData.bio,
                            // 'isGroupChat': false,
                            'profilePic': chatData.profilePic,
                          });
                        },
                        contentPadding: EdgeInsets.only(left: 4.0, right: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Colors.teal,
                            )),
                        leading: Container(
                          // height: 100,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    chatData.profilePic,
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                        title: Text(
                          chatData.name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(chatData.lastMessage),
                        trailing: Icon(CupertinoIcons.star),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return ErrorScreen(error: snapshot.error.toString());
            } else {
              return const LoadingIndicator();
            }
          }),
    );
  }
}
