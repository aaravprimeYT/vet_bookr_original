import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/features/OTP/phone_verification_2.dart';

class LoginController {
  bool isLoading = false;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    emailController.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInUser(String email, String password, BuildContext context) async {
    User? user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      var bar = SnackBar(content: Text("${user?.email} is signed in"));

      ScaffoldMessenger.of(context).showSnackBar(bar);

      /**
       * Go to Phone Verification
       */
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PV2(auth: _auth, fromLogin: true)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        const snackBar = SnackBar(content: Text("User not found"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        const snackBar2 = SnackBar(content: Text("Incorrect Password"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }
    }
  }

  tField({String? hText}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.01.sh),
      child: SizedBox(
        width: 0.9.sw,
        height: 40.sp,
        child: TextFormField(
          cursorColor: Colors.black,
          style: TextStyle(fontSize: 0.017.sh),
          controller: emailController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: Color(0xffFF8B6A))),
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.03.sw),
            hintStyle: TextStyle(fontSize: 0.017.sh),
            hintText: hText,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: Color(0xffFF8B6A))),
          ),
        ),
      ),
    );
  }

  tpField({String? hText}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.01.sh),
      child: SizedBox(
        width: 0.9.sw,
        height: 40.sp,
        child: TextFormField(
          cursorColor: Colors.black,
          obscureText: true,
          style: TextStyle(fontSize: 0.017.sh),
          controller: passwordController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: Color(0xffFF8B6A))),
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.03.sw),
            hintStyle: TextStyle(fontSize: 0.017.sh),
            hintText: hText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffFF8B6A)),
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
        ),
      ),
    );
  }
}
