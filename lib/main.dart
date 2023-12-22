import 'package:chat/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/error_screen.dart';
import 'common/loading_indicator.dart';
import 'controller/auth_controller.dart';
import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: GoogleFonts.didactGothic().fontFamily,
        //poppins
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        useMaterial3: true,
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const AuthScreen();
              }
              return HomeScreen();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const LoadingIndicator(),
          ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
