import 'dart:io';

import 'package:chat/common/error_screen.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/repository/firebase_storage_repository.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:chat/screens/otp_screen.dart';
import 'package:chat/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  void signInWithPhone(BuildContext context, phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(
            phoneAuthCredential,
          );
        },
        verificationFailed: (e) {
          print(e.message);
          showErrorBtmSheet(
            context,
            e.message!,
          );
        },
        codeSent: (((verificationId, forceResendingToken) async {
          Navigator.pushReplacementNamed(
            context,
            OtpScreen.routeName,
            arguments: verificationId,
          );
        })),
        codeAutoRetrievalTimeout: ((veridicationId) {}),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      if (context.mounted) {
        showErrorBtmSheet(
          context,
          e.message!,
        );
      }
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );
      await auth.signInWithCredential(
        credential,
      );
      Navigator.of(context).pushNamed(
        ProfileScreen.routeName,
      );
    } on FirebaseAuthException catch (e) {
      showErrorBtmSheet(context, e.message.toString());
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required String bio,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = '';
      if (profilePic != null) {
        photoUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        name: name,
        bio: bio,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      await auth.currentUser!.updateDisplayName(name);
      await auth.currentUser!.updatePhotoURL(photoUrl);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      showErrorBtmSheet(
        context,
        e.toString(),
      );
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> getUserData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void signOutUser() async {
    await auth.signOut();
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
