import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Login/login_controller.dart';
import 'package:vet_bookr/oScreens/forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = LoginController();

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
              loginController.tField(hText: 'Email'),
              loginController.tpField(hText: 'Password'),
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
                    if (loginController.emailController.text.isEmpty ||
                        loginController.passwordController.text.isEmpty) {
                      const snackBar = SnackBar(
                        content: Text("One of these fields is empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await loginController.signInUser(
                          loginController.emailController.text,
                          loginController.passwordController.text);
                      // }
                    }
                    setState(() {
                      loginController.isLoading = false;
                    });
                  },
                  child: loginController.isLoading
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
