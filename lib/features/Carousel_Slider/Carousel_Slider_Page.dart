import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Login/login_page.dart';
import 'package:vet_bookr/features/Signup/signup_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indicatorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
      body: ListView(
        children: [
          CarouselSlider(
            items: [
              Column(
                children: [
                  Image.asset(
                    "assets/Pet_Record_Storage.png",
                    width: 0.8.sw,
                    height: 0.75.sw,
                  ),
                  SizedBox(
                    height: 0.005.sh,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.01.sh),
                    child: Text(
                      "Store all your pet's records \nin one place",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PlaypenSans',
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                    child: Text(
                      "Upload any documents/photos of your pets' prescriptions and get reminders for your pets' next vaccinations!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  )
                ],
              ),

              //2nd Image of Slider
              Column(
                children: [
                  Image.asset(
                    "assets/Pet_Record_Storage.png",
                    width: 0.8.sw,
                    height: 0.75.sw,
                  ),
                  SizedBox(
                    height: 0.005.sh,
                  ),
                  Text(
                    "Ask pet related questions \nto Pet-GPT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: "Vintage Style",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                    child: Text(
                      "Ask our Pet-GPT for any pet related inquiries!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  )
                ],
              ),

              //3rd Image of Slider
              Column(
                children: [
                  Image.asset(
                    "assets/Pet_Record_Storage.png",
                    width: 0.8.sw,
                    height: 0.75.sw,
                  ),
                  SizedBox(
                    height: 0.005.sh,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.01.sh),
                    child: Text(
                      "Co-Parent with other family members/friends",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                    child: Text(
                      "Add co-parents such as family members or friends to easily share data of your pet!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  )
                ],
              ),

              //4th Image of Slider
              Column(
                children: [
                  Image.asset(
                    "assets/Pet_Record_Storage.png",
                    width: 0.8.sw,
                    height: 0.75.sw,
                  ),
                  SizedBox(
                    height: 0.005.sh,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.01.sh),
                    child: Text(
                      "Lost & Found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh, left: 0.07.sw, right: 0.07.sw),
                    child: Text(
                      "Send a notification to other users in a certain radius to let them know about your missing pet!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  )
                ],
              ),

              //5th Image of Slider
              Column(
                children: [
                  Image.asset(
                    "assets/Pet_Record_Storage.png",
                    width: 0.8.sw,
                    height: 0.75.sw,
                  ),
                  SizedBox(
                    height: 0.005.sh,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.01.sh),
                    child: Text(
                      "Find Clinics, Pharmacies\n & Pet-friendly places nearby",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                    child: Text(
                      "Find clinics, pharmacies & pet-friendly places within a 2.5-50km radius. Search globally for your holidays too!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: "Vintage Style",
                      ),
                    ),
                  )
                ],
              ),
            ],

            //Slider Container properties
            options: CarouselOptions(
                height: 0.6.sh,
                autoPlay: false,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    indicatorIndex = index;
                  });
                }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.003.sh, left: 0.4.sw),
            child: AnimatedSmoothIndicator(
              activeIndex: indicatorIndex,
              count: 5,
              effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Color(0xffFF8B6A),
                  dotColor: Color(0xff65C3FF)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0.125.sw, right: 0.125.sw),
            child: Padding(
              padding: EdgeInsets.only(top: 0.02.sh),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xffFF8B6A)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text(
                  "Sign up now",
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.005.sh),
                child: Text(
                  "Already have an account?  ",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  child: Text(
                    "Log In",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14.sp, color: Color(0xffFF8B6A)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
