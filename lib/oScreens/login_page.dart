import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/oScreens/forgot_password.dart';
import 'package:vet_bookr/oScreens/phone_verification_2.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInUser(String email, String password) async {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: kBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: kBackgroundColor,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              Image.asset(
                "assets/logo.png",
                width: 0.75.sw,
              ),

              SizedBox(height: 0.03.sh),
              //sBox(h: 3),
              tField(hText: 'Email'),
              tpField(hText: 'Password'),
              //sBox(h: 2),
              SizedBox(height: 0.005.sh),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 0.1.sw),
                  width: 1.sw,
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              SizedBox(height: 0.05.sh),
              Container(
                height: 0.05.sh,
                width: 0.25.sw,
                child: TextButton(
                  style: TextButton.styleFrom(
                      //fixedSize: Size(SizeConfig.blockSizeHorizontal! * 30,
                      //  SizeConfig.blockSizeVertical! * 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp)),
                      backgroundColor: Color(0xffFF8B6A)),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      _password = passwordController.text;
                      email = emailController.text;
                    });
                    if (email.isEmpty || _password.isEmpty) {
                      const snackBar = SnackBar(
                        content: Text("One of these fields is empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await signInUser(email, _password);
                      // }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: isLoading
                      ? Container(
                          height: 15.sp,
                          width: 15.sp,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.sp,
                          ),
                        )
                      : Text(
                          'Login',
                          style:
                              TextStyle(color: Colors.white, fontSize: 0.03.sw),
                        ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
