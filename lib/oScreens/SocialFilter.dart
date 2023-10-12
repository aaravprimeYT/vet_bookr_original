import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Boarding/petBoarding_page.dart';
import 'package:vet_bookr/features/Pet_Cafe/petCafes_page.dart';
import 'package:vet_bookr/features/Pet_Grooming/petGrooming_page.dart';
import 'package:vet_bookr/features/Pet_Parks/petParks_page.dart';
import 'package:vet_bookr/features/Pet_Resorts/petResorts_page.dart';
import 'package:vet_bookr/features/Pet_Restaurants/petRestaurants_page.dart';
import 'package:vet_bookr/oScreens/petTrainers_page.dart';

class PetSocialFilter extends StatelessWidget {
  PetSocialFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
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
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.03.sp),
            child: Text(
              'Find more fun for your pet',
              style: TextStyle(color: Color(0xffFF8B6A), fontSize: 20.sp),
            ),
          ),
          Divider(
            thickness: 2,
            color: Color(0xffFF8B6A),
            endIndent: 65,
            indent: 70,
          ),
          Row(children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: 0.12.sw, top: 15.sp, left: 0.12.sw),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetResortsPage()));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFAEEE2)),
                        shape: MaterialStateProperty.all(CircleBorder())),
                    child: Image.asset("assets/vacations.png",
                        width: 0.25.sw, height: 0.225.sw),
                  ),
                ),
                Text(
                  "Resorts",
                  style:
                      TextStyle(fontSize: 16.sp, fontFamily: "Vintage Style"),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.sp, bottom: 2.sp),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetCafesPage()));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFAEEE2)),
                        shape: MaterialStateProperty.all(CircleBorder())),
                    child: Image.asset("assets/cafes.png",
                        width: 0.25.sw, height: 0.225.sw),
                  ),
                ),
                Text(
                  "Cafes",
                  style:
                      TextStyle(fontSize: 16.sp, fontFamily: "Vintage Style"),
                ),
              ],
            ),
          ]),
          Row(children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: 0.12.sw, top: 15.sp, bottom: 5.sp, left: 0.12.sw),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetRestaurantsPage()));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFAEEE2)),
                        shape: MaterialStateProperty.all(CircleBorder())),
                    child: Image.asset("assets/restaurants.png",
                        width: 0.25.sw, height: 0.25.sw),
                  ),
                ),
                Text(
                  "Restaurants",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "Vintage Style",
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.sp, bottom: 5.sp),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetTrainersPage()));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xffFAEEE2)),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),
                    child: Image.asset("assets/trainers.png",
                        width: 0.25.sw, height: 0.23.sw),
                  ),
                ),
                Text(
                  "Trainers",
                  style:
                      TextStyle(fontSize: 16.sp, fontFamily: "Vintage Style"),
                ),
              ],
            ),
          ]),
          Row(children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: 0.12.sw, top: 15.sp, bottom: 5.sp, left: 0.12.sw),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetBoardersPage()));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFAEEE2)),
                        shape: MaterialStateProperty.all(CircleBorder())),
                    child: Image.asset("assets/boarding.png",
                        width: 0.25.sw, height: 0.25.sw),
                  ),
                ),
                Text(
                  "Boarding",
                  style:
                      TextStyle(fontSize: 16.sp, fontFamily: "Vintage Style"),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.sp, bottom: 5.sp),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PetGroomersPage()));
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFAEEE2)),
                        shape: MaterialStateProperty.all(CircleBorder())),
                    child: Image.asset("assets/grooming.png",
                        width: 0.25.sw, height: 0.25.sw),
                  ),
                ),
                Text(
                  "Grooming",
                  style:
                      TextStyle(fontSize: 16.sp, fontFamily: "Vintage Style"),
                ),
              ],
            ),
          ]),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.sp, bottom: 3.sp),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetParksPage()));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffFAEEE2)),
                    shape: MaterialStateProperty.all(CircleBorder()),
                  ),
                  child: Image.asset("assets/parks.png",
                      width: 0.25.sw, height: 0.15.sw),
                ),
              ),
              Text(
                "Parks",
                style: TextStyle(fontSize: 16.sp, fontFamily: "Vintage Style"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
