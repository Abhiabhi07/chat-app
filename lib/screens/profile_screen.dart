import 'dart:io';

import 'package:chat/controller/auth_controller.dart';
import 'package:chat/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/custom_form_field.dart';
import '../widgets/user_image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  var userName;
  var bio;
  var isLoading = false;
  File? pickedImage;
  final formKey = GlobalKey<FormState>();

  void storeUserData(BuildContext context, WidgetRef ref) async {
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    ref.read(authControllerProvider).saveUserDataToFirebase(
          context,
          userName,
          bio,
          pickedImage,
        );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              UserImagePicker(
                pickedImage: (image) {
                  pickedImage = image;
                },
              ),
              CustomFormField(
                title: 'Username',
                hintText: 'enter your username',
                validator: (val) {},
                onSaved: (saved) {
                  userName = saved;
                },
                textCapitalization: true,
              ),
              CustomFormField(
                title: 'Bio',
                hintText: 'enter your bio',
                validator: (val) {},
                onSaved: (saved) {
                  bio = saved;
                },
                textCapitalization: true,
              ),
              SizedBox(
                height: 50,
              ),
              AuthButton(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Proceed',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                  onPressed: () {
                    storeUserData(context, ref);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
