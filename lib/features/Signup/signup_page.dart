import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Signup/signup_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignupController signupController = SignupController();

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
        extendBodyBehindAppBar: true,
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
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 0.75.sw,
            ),
            SizedBox(height: 0.03.sh),
            signupController.tField(hText: 'Email'),
            signupController.tpField(hText: 'Password'),
            //sBox(h: 2),
            SizedBox(height: 0.05.sh),
            Container(
              height: 0.05.sh,
              width: 0.25.sw,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp)),
                    backgroundColor: Color(0xff5EBB86)),
                onPressed: () async {
                  if (signupController.emailController.text.isEmpty ||
                      signupController.passwordController.text.isEmpty) {
                    const snackBar = SnackBar(
                      content: Text("One of these fields is empty"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    await signupController.signupUser(
                        signupController.emailController.text,
                        signupController.passwordController.text,
                        context);
                    setState(() {
                      signupController.isLoading = false;
                    });
                  }
                },
                child: signupController.isLoading
                    ? Container(
                        height: 15.sp,
                        width: 15.sp,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.sp,
                        ),
                      )
                    : Text(
                        'Sign Up',
                        style:
                            TextStyle(color: Colors.white, fontSize: 0.03.sw),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
