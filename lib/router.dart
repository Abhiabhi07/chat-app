import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/conatcts_screen.dart';
import 'package:flutter/material.dart';

import 'common/error_screen.dart';
import 'screens/home_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/profile_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ContactsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const ContactsScreen());

    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;

      return MaterialPageRoute(
          builder: (context) => OtpScreen(
                verificationId: verificationId,
              ));

    case ProfileScreen.routeName:
      return MaterialPageRoute(builder: (context) => ProfileScreen());

    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) => HomeScreen());

    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<dynamic, dynamic>;
      final name = arguments['name'];
      final bio = arguments['bio'];
      final uid = arguments['uid'];
      // final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          name: name,
          bio: bio,
          uid: uid,
          profilePic: profilePic,
          // isGroupChat: isGroupChat,
        ),
      );

    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'This page doesn\'t exist'),
              ));
  }
}
