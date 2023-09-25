import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:vet_bookr/features/OTP/OTP_controller.dart';

class PV2 extends StatefulWidget {
  final FirebaseAuth auth;
  bool fromLogin;

  PV2({Key? key, required this.auth, required this.fromLogin})
      : super(key: key);

  @override
  State<PV2> createState() => _PV2State();
}

class _PV2State extends State<PV2> {
  OTPController otpController = OTPController();

  String phoneController = otpController._phoneController.text();

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
                child: otpController.otpNotSent
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
                                  otpController.phoneController.text =
                                      phone.completeNumber;
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
                              keyboardType: TextInputType.number,
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
}
