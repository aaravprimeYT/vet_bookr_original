import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/sizeConfig.dart';
import 'package:vet_bookr/oScreens/signup_page.dart';

import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 0.02.sw, top: 0.05.sh, bottom: 0.02.sh),
              child: Image.asset(
                "assets/logo.png",
                height: 0.11.sh,
                width: 0.6.sw,
              ),
            ),

            Image.asset(
              "assets/welcome.png",
              width: 0.27.sw,
              height: 0.05.sh,
            ),
            //sBox(h: 2),
            Padding(
              padding: EdgeInsets.only(top: 0.02.sh),
              child: Padding(
                padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
                child: Text(
                  "Vet Bookr is the all-in-one app for \npet parents to find a vet, pet-friendly places and pharmacies nearby, with the unique convenience of storing your pet's health records in one place for the future reference.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      height: 0.0023.sh,
                      fontSize: 13.sp),
                ),
              ),
            ),
            SizedBox(height: 0.04.sh,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 0.25.sw,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        //fixedSize: Size(SizeConfig.blockSizeHorizontal! * 20,
                        //  SizeConfig.blockSizeVertical! * 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Color(0xff5EBB86)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white,fontSize: 12.sp),
                    ),
                  ),
                ),
                Container(
                  width: 0.25.sw,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        //fixedSize: Size(SizeConfig.blockSizeHorizontal! * 20,
                        //  SizeConfig.blockSizeVertical! * 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Color(0xffFF8B6A)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white,fontSize: 12.sp),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 0.05.sh,),
            Container(
              width: 1.sw,
              height: 0.47.sh,
              child: Image.asset(
                'assets/homepage.png',
              ),
            )
          ],
        ),
      ),
    );
  }
}
