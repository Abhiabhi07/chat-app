import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/controller/auth_controller.dart';
import 'package:chat/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';
  final String verificationId;

  OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  // void verifyOtp(WidgetRef ref, BuildContext context, String userOtp) {
  //   ref
  //       .read(authControllerProvider)
  //       .verifyOtp(context, verificationId, userOtp);
  // }

  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  void verifyOtp(
    WidgetRef ref,
    BuildContext context,
  ) {
    String completeOTP =
        controllers.map((controller) => controller.text).join();
    ref
        .read(authControllerProvider)
        .verifyOtp(context, verificationId, completeOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your phone number'),
        elevation: 0,
        // backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl:
                  'https://img.freepik.com/free-vector/enter-otp-concept-illustration_114360-7887.jpg?size=626&ext=jpg&ga=GA1.1.1936823732.1701874652&semt=ais',
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: RichText(
                text: const TextSpan(
                  text: 'We have sent verification code to ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '+91-1234569870',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.green),
                  ),
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        // Move focus to the next TextField when a digit is entered
                        if (index < 5) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else {
                          // If the last digit is entered, unfocus the current TextField
                          focusNodes[index].unfocus();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            AuthButton(
              child: Text(
                'Verify OTP',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              // color: Colors.green,
              onPressed: () {
                verifyOtp(
                  ref,
                  context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
