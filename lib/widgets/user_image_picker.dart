import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const profilePhoto = 'https://cdn-icons-png.flaticon.com/128/3177/3177440.png';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) pickedImage;

  const UserImagePicker({super.key, required this.pickedImage});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImage = File(pickedImage.path);
    });
    widget.pickedImage(_pickedImage!);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //final user = auth.currentUser!;
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _pickedImage != null
                  ? FileImage(File(_pickedImage!.path))
                  : const NetworkImage(
                      profilePhoto,
                    ) as ImageProvider,
            ),
          ),
          Positioned(
              bottom: 10.0,
              right: 0.0,
              child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.greenAccent,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: pickImage,
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 15,
                      ))))
        ],
      ),
    );
  }
}
