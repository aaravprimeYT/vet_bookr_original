import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_bookr/oScreens/pharma_Loading.dart';
import 'package:vet_bookr/oScreens/social_loading.dart';

import 'authenticator.dart';
import 'clinicsloading.dart';
import 'list_pet.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Container(),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/menu_background.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0.26.sw, top: 0.02.sh),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 0.13.sh,
                      width: 0.47.sw,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.13.sw, top: 0.03.sh),
                    child: IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                        await preferences.setBool('isUserLoggedIn', false);
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authenticator()));
                          },
                        );
                      },
                      icon: Icon(
                        Icons.logout,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1.sw,
              margin: EdgeInsets.only(
                top: 0.06.sh,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListPets(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        child: Image.asset(
                          "assets/My_Pet_Profile.png",
                          width: 0.27.sw,
                          height: 0.27.sw,
                        ),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Text(
                        "My Pets",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: "Vintage Style",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xffFAEEE2)),
                          shape: MaterialStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        child: Image.asset(
                          "assets/Find_a_Pet.png",
                          width: 0.27.sw,
                          height: 0.27.sw,
                        ),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Text(
                        "Find a Vet",
                        style: TextStyle(
                            fontSize: 16.sp, fontFamily: "Vintage Style"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 1.sw,
              margin: EdgeInsets.only(
                top: 0.06.sh,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PharmaLoading(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffFAEEE2),
                          ),
                          shape: MaterialStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        child: Image.asset(
                          "assets/Find_A_Pet_Pharmacy.png",
                          width: 0.27.sw,
                          height: 0.27.sw,
                        ),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Text(
                        "Find a Pet \nPharmacy",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: "Vintage Style",
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SocialLoading(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffFAEEE2),
                          ),
                          shape: MaterialStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                        child: Image.asset(
                          "assets/Pet_Social.png",
                          fit: BoxFit.contain,
                          width: 0.27.sw,
                          height: 0.27.sw,
                        ),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Text(
                        "Pet Social",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: "Vintage Style",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
