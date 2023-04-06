import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/oScreens/list_pet.dart';
import 'package:vet_bookr/oScreens/pharma_Loading.dart';
import 'package:vet_bookr/oScreens/social_loading.dart';
import 'package:vet_bookr/oScreens/welcome_screen.dart';

import 'clinicsloading.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isLoading = false;
  var count = 0;

  void checkLogin() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListPets(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: Container(),
              toolbarHeight: 0.1.sh,
              centerTitle: true,
              title: Image.asset(
                "assets/logo.png",
                height: 0.13.sh,
                width: 0.47.sw,
              ),
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/menu_background.png"),
                    fit: BoxFit.cover),
              ),
              child: isLoading
                  ? Container(
                      height: 2.sp,
                      width: 2.sp,
                      child: CircularProgressIndicator(
                        color: Color(0xffFF8B6A),
                        strokeWidth: 2.sp,
                      ),
                    )
                  : Column(children: [
                      Container(
                        padding: EdgeInsets.only(top: 0.2.sh),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xffFAEEE2)),
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
                                      fontSize: 16.sp,
                                      fontFamily: "Vintage Style"),
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
                                    height: 0.23.sw,
                                  ),
                                ),
                                SizedBox(
                                  height: 0.005.sh,
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
                                    height: 0.22.sw,
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
                    ]),
            ),
          )
        : WelcomePage();
  }
}
