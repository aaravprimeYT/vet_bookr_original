import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_bookr/oScreens/pharma_Loading.dart';
import 'package:vet_bookr/oScreens/social_loading.dart';
import 'package:vet_bookr/oScreens/welcome_screen.dart';

import 'authenticator.dart';
import 'clinicsloading.dart';
import 'list_pet.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 0.015.sh),
            child: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Logout"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Delete User"),
                    ),
                  ];
                },
                onSelected: (value) async {
                  if (value == 0) {
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();

                    await preferences.setBool('isUserLoggedIn', false);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Authenticator()));
                      print("log out");
                    });
                  } else if (value == 1) {
                    isLoading = true;
                    // final petsDetails = FirebaseFirestore.instance
                    //     .collection("users")
                    //     .doc(FirebaseAuth.instance.currentUser?.uid)
                    //     .get();
                    // print(petsDetails);
                    //
                    // final petFiles = FirebaseFirestore.instance
                    //     .collection("petsDetails")
                    //     .doc()
                    //     .get();
                    //
                    // print(petFiles);

                    var userDetails = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get();

                    for (var petId in userDetails.data()!['pets']) {
                      var petDetails = await FirebaseFirestore.instance
                          .collection('petsDetails')
                          .doc(petId)
                          .get();
                      var petFilesIds = petDetails.data()!["petFiles"];
                      for (var petFileId in petFilesIds) {
                        var fileDetails = await FirebaseFirestore.instance
                            .collection('petFiles')
                            .doc(petFileId)
                            .get();
                        print(fileDetails.data());

                        await FirebaseFirestore.instance
                            .collection("petsDetails")
                            .doc(petId)
                            .update({
                          'petFiles': FieldValue.arrayRemove(
                              [fileDetails.data()!["id"]])
                        });
                        final deleteFile = FirebaseFirestore.instance
                            .collection("petFiles")
                            .doc(fileDetails.data()!["id"]);
                        await deleteFile.delete();
                      }
                      await FirebaseFirestore.instance
                          .collection("petsDetails")
                          .doc(petId)
                          .delete();
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({
                        'pets': FieldValue.arrayRemove([petId]),
                      });
                    }
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .delete();

                    await FirebaseAuth.instance.currentUser?.delete();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WelcomePage()));
                  }
                }),
          )
        ],
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
                height: 15.sp,
                width: 15.sp,
                child: CircularProgressIndicator(
                  color: Colors.white,
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
    );
  }
}
