import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../oScreens/list_pet.dart';

class OTPController {
  bool isLoading = false;

  String globalVerificationId = "";
  bool otpNotSent = true;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  verifyPhoneNo(String phoneNo) async {
    await widget.auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          var existingUser = widget.auth.currentUser;

          //After the User  SignsIn
          await existingUser?.linkWithCredential(credential).then((value) {
            const snackBar =
                SnackBar(content: Text("User Signed In SuccessFully"));
            ScaffoldMessenger.of(context as BuildContext)
                .showSnackBar(snackBar);
          });
        },
        /**
         * Handles only invalid phone no.s or if sms quota expired
         */
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            const snackBar = SnackBar(
                content: Text('The provided phone number is not valid.'));
            ScaffoldMessenger.of(context as BuildContext)
                .showSnackBar(snackBar);
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isLoading = false;
            otpNotSent = false;
            globalVerificationId = verificationId;
          });
          const snackBar = SnackBar(content: Text('OTP Sent.'));
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  validateOTP(String otp) async {
    //Validate the OTP by calling a function in Auth

    try {
      User user = widget.auth.currentUser!;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: globalVerificationId, smsCode: otp);
      if (widget.fromLogin == false) {
        user.linkWithCredential(credential);
        print("this code works");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.auth.currentUser?.uid)
            .set({
          "email": widget.auth.currentUser?.email,
          "phone": _phoneController.text,
          "id": widget.auth.currentUser?.uid,
          "pets": []
        });
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setBool('isUserLoggedIn', true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context as BuildContext,
            MaterialPageRoute(builder: (context) => ListPets()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        const snackBar =
            SnackBar(content: Text("Invalid OTP. Please Enter Correct OTP"));
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
  }
}
