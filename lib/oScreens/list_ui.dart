import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/oScreens/showPetScreen.dart';

import '../constant.dart';
import 'addPet_screen.dart';

class ListUI extends StatefulWidget {
  ListUI({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<ListUI> createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {
  @override
  void initState() {
    getPetDetails();
    super.initState();
  }

  void getPetDetails() async {
    DocumentSnapshot<Map<String, dynamic>> petDetails = await FirebaseFirestore
        .instance
        .collection("petsDetails")
        .doc(widget.id)
        .get();
    //print(widget.id);
    details = petDetails.data()!;
    setState(() {
      isLoading = false;
    });
    print(petDetails.data());
  }

  late Map<String, dynamic> details;

  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
          padding: EdgeInsets.all(75.sp),
          child: CircularProgressIndicator(color: Color(0xffFF8B6A),),
        )
        : GestureDetector(
            onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowPet(details: details)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(details["profilePicture"]),
                        radius: 40.sp,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.01.sh),
                      child: Text(
                        "${details["name"]}",
                        style:
                            TextStyle(fontSize: 20.sp, color: Color(0xffF08714)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.01.sh),
                      child: Text(
                        "${details["breed"]}",
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
