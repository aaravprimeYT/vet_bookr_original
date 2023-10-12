import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteUserController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future deleteUser(String email, String password) async {
    try {
      User user = _auth.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);

      if (result.user != null) {
        await result.user!.delete();
      }
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
