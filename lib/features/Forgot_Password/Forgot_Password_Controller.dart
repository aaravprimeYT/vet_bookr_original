import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController {
  bool isLoading = false;

  String globalVerificationId = "";
  bool otpNotSent = true;
  final emailController = TextEditingController();

  Future<void> passwordReset(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException catch (err) {
      var snackBar = SnackBar(
        content: Text(err.message.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
