import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/oScreens/AddPetFiles.dart';
import 'package:vet_bookr/oScreens/petFiles.dart';

import '../constant.dart';

class ShowPet extends StatefulWidget {
  ShowPet({Key? key, required this.details}) : super(key: key);

  Map<String, dynamic> details;


  @override
  State<ShowPet> createState() => _ShowPetState();
}

class _ShowPetState extends State<ShowPet> {
  List<String> labels = ["Name", "Age", "Breed", "Weight"];

  var getText = "";

  bool isLoading = false;

  String controllerChanger(index) {
    if (index == 0) {
      return widget.details["name"];
    }
    if (index == 1) {
      return widget.details["age"];
    }
    if (index == 2) {
      return widget.details["breed"];
    }
    if (index == 3) {
      return widget.details["weight"];
    }
    return getText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          Padding(padding: EdgeInsets.only(right: 5.sp),
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.black,),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(value: 0, child: Text("Edit Pet")), PopupMenuItem<int>(value: 1, child: Text("Delete Pet"))
                  ];
                },
                onSelected: (value)async {
                  if(value == 0){

                  }
                  else if (value == 1){
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseFirestore
                        .instance
                        .collection("petsDetails")
                        .doc(widget.details["id"]).delete();

                    await FirebaseFirestore
                    .instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .update({'pets':FieldValue.arrayRemove([widget.details["id"]])});
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  }
                },
              )
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,

      body: isLoading ? Container(child: CircularProgressIndicator())  :
      SafeArea(
        child: Container(
          //alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // sBox(h: 10),
                  Text(
                    'Pet Information',
                    style:
                    TextStyle(color: Color(0xffF08519), fontSize: 0.05.sw),
                  ),
                  //      myPetTile()
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  GestureDetector(
                      child: CircleAvatar(
                        radius: 0.095.sh,
                        backgroundColor: Color(0xffFF8B6A),
                        backgroundImage:
                        NetworkImage(widget.details["profilePicture"]),
                      )),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  ...List.generate(
                    4,
                        (index) =>
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                          child: TextField(
                            enabled: false,
                            controller: TextEditingController(
                                text: controllerChanger(index)),
                            style: TextStyle(fontSize: 0.017.sh),
                            decoration: InputDecoration(
                              label: Text(labels[index],
                                  style: TextStyle(fontSize: 0.02.sh)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide(
                                      color: Color(0xffFF8B6A))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  borderSide: BorderSide(
                                      color: Color(0xffFF8B6A))),
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.sp),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh,
                        left: 0.05.sw,
                        right: 0.05.sw,
                        bottom: 0.02.sh),
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(
                          text: "${widget.details["lastVaccinationDate"]}"),
                      readOnly: true,
                      style: TextStyle(fontSize: 0.017.sh),
                      decoration: InputDecoration(
                        label: Text("Last Vaccination Date",
                            style: TextStyle(fontSize: 0.02.sh)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                    ),
                  ),
                  buttonWidget()
                ],
              ),
            ),
          ),
        ),
      ) ,
    );
  }

  Widget buttonWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 0.4.sw,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF8B6A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PetFiles(
                                  petId: widget.details["id"],
                                )));
                  },
                  child: Text(
                    "Pet Health Records",
                    style: TextStyle(
                        fontSize: 0.029.sw, fontWeight: FontWeight.w400),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
