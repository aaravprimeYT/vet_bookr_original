import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_bookr/oScreens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PV2 extends StatefulWidget {
  final FirebaseAuth auth;
  bool fromLogin;

  PV2({Key? key, required this.auth, required this.fromLogin})
      : super(key: key);

  @override
  State<PV2> createState() => _PV2State();
}

class _PV2State extends State<PV2> {
  bool isLoading = false;

  String globalVerificationId = "";
  bool otpNotSent = true;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

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
                padding: EdgeInsets.only(top: 0.1.sh, bottom: 0.01.sh),
                child: Container(
                    height: 0.1.sh, child: Image.asset("assets/logo.png")),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.05.sh, bottom: 0.083.sh),
                child: Container(
                    height: 0.15.sh, child: Image.asset("assets/icon1.png")),
              ),
              Container(
                color: Color(0xffFFF5F0),
                padding: EdgeInsets.all(0.07.sh),
                child: otpNotSent
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // DropdownButton(items: [], onChanged: (){}),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          Container(
                            width: 0.8.sw,
                            height: 0.08.sh,
                            child: IntlPhoneField(
                              style: TextStyle(fontSize: 0.017.sh),
                              cursorColor: Colors.black,
                              dropdownTextStyle: TextStyle(
                                fontSize: 0.017.sh,
                              ),
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 0.02.sh,
                              ),
                              dropdownIconPosition: IconPosition.leading,
                              disableLengthCheck: true,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.00.sh, horizontal: 0.03.sw),
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 0.017.sh),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                setState(() {
                                  _phoneController.text = phone.completeNumber;
                                });
                              },
                            ),
                          ),

                          SizedBox(height: 0.04.sh),
                          Text(
                            "We will send you a One Time SMS message.\nCarrier rates may apply",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0.04.sh),
                          Container(
                            height: 50.sp,
                            width: 50.sp,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_phoneController.text.isEmpty) {
                                  const snackBar = SnackBar(
                                      content: Text("Phone No is empty"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  await verifyPhoneNo(_phoneController.text);
                                }
                                print(_phoneController.text);
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(0xff6AC4FF),
                                child: isLoading
                                    ? Container(
                                        height: 15.sp,
                                        width: 15.sp,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.sp,
                                        ),
                                      )
                                    : Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.1.sh,
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          Container(
                            height: 60.sp,
                            width: 0.8.sw,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(fontSize: 0.017.sh),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.01.sh, horizontal: 0.03.sw),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide(),
                                ),
                                filled: true,
                                fillColor: Color(0xffFFF5F0),
                                hintText: "Enter OTP",
                                hintStyle: TextStyle(fontSize: 0.017.sh),
                              ),
                              controller: _otpController,
                            ),
                          ),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          Text(
                            "Enter the OTP that you have received on \n registered mobile number",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 0.03.sh,
                          ),
                          Container(
                            height: 50.sp,
                            width: 50.sp,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_otpController.text.isEmpty) {
                                  const snackBar = SnackBar(
                                      content:
                                          Text("Empty OTP cannot be sent"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  validateOTP(_otpController.text);
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(0xff6AC4FF),
                                child: isLoading
                                    ? Container(
                                        height: 15.sp,
                                        width: 15.sp,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.sp,
                                        ),
                                      )
                                    : Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          SizedBox(
                            height: 0.1.sh,
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  verifyPhoneNo(String phoneNo) async {
    await widget.auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          var existingUser = widget.auth.currentUser;

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
          setState(() {
            isLoading = false;
            otpNotSent = false;
            globalVerificationId = verificationId;
          });
          const snackBar = SnackBar(content: Text('OTP Sent.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MenuScreen()));
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
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
