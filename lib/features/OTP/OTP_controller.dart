import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pet_List/list_pet.dart';

class OTPController {
  bool isLoading = false;

  String globalVerificationId = "";
  bool otpNotSent = true;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  verifyPhoneNo(String phoneNo, FirebaseAuth auth, BuildContext context) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          var existingUser = auth.currentUser;

          //After the User  SignsIn
          await existingUser?.linkWithCredential(credential).then((value) {
            const snackBar =
                SnackBar(content: Text("User Signed In SuccessFully"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        },
        /**
         * Handles only invalid phone no.s or if sms quota expired
         */
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            const snackBar = SnackBar(
                content: Text('The provided phone number is not valid.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          isLoading = false;
          otpNotSent = false;
          globalVerificationId = verificationId;
          const snackBar = SnackBar(content: Text('OTP Sent.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  validateOTP(String otp, FirebaseAuth auth, bool fromLogin,
      BuildContext context) async {
    //Validate the OTP by calling a function in Auth
    try {
      User user = auth.currentUser!;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: globalVerificationId, smsCode: otp);
      if (fromLogin == false) {
        user.linkWithCredential(credential);
        print("this code works");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(auth.currentUser?.uid)
            .set({
          "email": auth.currentUser?.email,
          "phone": phoneController.text,
          "id": auth.currentUser?.uid,
          "pets": []
        });
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setBool('isUserLoggedIn', true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListPets()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        const snackBar =
            SnackBar(content: Text("Invalid OTP. Please Enter Correct OTP"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
  }
}
