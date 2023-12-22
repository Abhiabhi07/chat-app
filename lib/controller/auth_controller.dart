import 'dart:io';

import 'package:chat/model/user_model.dart';
import 'package:chat/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    ref: ref,
  );
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(
      context,
      phoneNumber,
    );
  }

  void verifyOtp(BuildContext context, String verificationId, String userOtp) {
    authRepository.verifyOtp(
      context: context,
      verificationId: verificationId,
      userOtp: userOtp,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, String bio, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      name: name,
      bio: bio,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> getUserDataById(String userId) {
    return authRepository.getUserData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  void signOutUser() {
    authRepository.signOutUser();
  }
}
