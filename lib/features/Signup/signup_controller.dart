import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';

import '../OTP/phone_verification_2.dart';

class SignupController {
  String email = "";
  String _password = "";

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

  signupUser(String email, String password) async {
    User? user;

    /**
     * Link credentials to the user.
     */

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

      var bar = SnackBar(content: Text("${user?.email} has signed up"));
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(bar);
      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(
            builder: (context) => PV2(
                  auth: _auth,
                  fromLogin: false,
                )),
      );
    } on FirebaseAuthException catch (error) {
      var bar = SnackBar(content: Text("${error.message}"));
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(bar);
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PV2(auth: _auth)),
    // );
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
                borderSide: BorderSide(color: Color(0xff5EBB86))),
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.03.sw),
            hintStyle: TextStyle(fontSize: 0.017.sh),
            hintText: hText,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: Color(0xff5EBB86))),
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
                borderSide: BorderSide(color: Color(0xff5EBB86))),
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.03.sw),
            hintStyle: TextStyle(fontSize: 0.017.sh),
            hintText: hText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff5EBB86)),
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
        ),
      ),
    );
  }
}
