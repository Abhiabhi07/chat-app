import 'package:chat/common/error_screen.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withPhoto: true,
          withThumbnail: true,
          withProperties: true,
        );
      }
    } catch (e) {
      print(e);
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNumb = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (selectedPhoneNumb == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, ChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'bio': userData.bio,
            'profilePic': userData.profilePic,
          });
        }

        if (!isFound) {
          showErrorBtmSheet(context, 'This user not available');
        }
      }
    } catch (e) {
      showErrorBtmSheet(context, e.toString());
    }
  }
}
