import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_form_field.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  var isSignUp = false;
  // AuthController authController = AuthController();
  bool isLoading = false;
  final globalKey = GlobalKey<FormState>();
  var phoneNumber;

  void authenticateUser() async {
    globalKey.currentState!.save();
    ref.read(authControllerProvider).signInWithPhone(
          context,
          '+91$phoneNumber',
        );

    // Navigator.of(context).pushNamed(
    //   OtpScreen.routeName,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: globalKey,
          child: ListView(
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://img.freepik.com/free-vector/messages-concept-illustration_114360-4485.jpg?size=626&ext=jpg&ga=GA1.1.1936823732.1701874652&semt=ais',
                height: 300,
              ),
              CustomFormField(
                title: 'Phone number',
                hintText: 'enter your phone number',
                keyboardType: TextInputType.number,
                validator: (val) {},
                onSaved: (saved) {
                  phoneNumber = saved;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              AuthButton(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        'Send OTP',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                onPressed: authenticateUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
