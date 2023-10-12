import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/features/Forgot_Password/Forgot_Password_Controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordController forgotPasswordController =
      ForgotPasswordController();

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
        backgroundColor: Color(0xffFFD9B3),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.1.sh, bottom: 0.1.sh),
                child: Container(
                    height: 0.2.sh,
                    child: Image.asset("assets/forgotPasswordIcon.png")),
              ),
              Container(
                  color: Color(0xffFFF5F0),
                  padding: EdgeInsets.all(0.03.sh),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.sp),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "We will need your registered Email Id\nto send you password reset instructions",
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.02.sw, vertical: 0.01.sh),
                        child: SizedBox(
                          width: 0.9.sw,
                          height: 40.sp,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            style: TextStyle(fontSize: 0.017.sh),
                            controller:
                                forgotPasswordController.emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide:
                                      BorderSide(color: Color(0xffFF8B6A))),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.01.sh, horizontal: 0.03.sw),
                              hintStyle: TextStyle(fontSize: 0.017.sh),
                              hintText: "Registered Email Id",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide:
                                      BorderSide(color: Color(0xffFF8B6A))),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.01.sh),
                      Container(
                        height: 0.05.sh,
                        width: 0.82.sw,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              //fixedSize: Size(SizeConfig.blockSizeHorizontal! * 30,
                              //  SizeConfig.blockSizeVertical! * 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp)),
                              backgroundColor: Color(0xff5EBB86)),
                          onPressed: () async {
                            setState(() {
                              forgotPasswordController.isLoading = true;
                            });
                            if (forgotPasswordController
                                .emailController.text.isEmpty) {
                              const snackBar = SnackBar(
                                content: Text("Please enter an Email Id"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              await forgotPasswordController
                                  .passwordReset(context);
                              var snackBar = SnackBar(
                                content: Text(
                                    "Password reset link is sent successfully"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            setState(() {
                              forgotPasswordController.isLoading = false;
                            });
                          },
                          child: forgotPasswordController.isLoading
                              ? Container(
                                  height: 15.sp,
                                  width: 15.sp,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.sp,
                                  ),
                                )
                              : Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 0.03.sw),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Container(
                          width: 0.6.sw,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset("assets/BackButton.png"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0),
                          )),
                      SizedBox(
                        height: 0.2.sh,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
