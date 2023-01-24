import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/oScreens/showPdf.dart';
import 'package:vet_bookr/oScreens/showPetScreen.dart';

import '../constant.dart';
import 'addPet_screen.dart';

class FileUI extends StatefulWidget {
  FileUI({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<FileUI> createState() => _FileUIState();
}

class _FileUIState extends State<FileUI> {
  @override
  void initState() {
    getFileDetails();
    super.initState();
  }

  void getFileDetails() async {
    DocumentSnapshot<Map<String, dynamic>> petDetails = await FirebaseFirestore
        .instance
        .collection("petFiles")
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
        ? Padding(
            padding: EdgeInsets.all(0.095.sh),
            child: CircularProgressIndicator(
              color: Color(0xffFF8B6A),
            ),
          )
        : GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Container(
                    width: 0.42.sw,
                    padding: EdgeInsets.only(left: 0.03.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.015.sh),
                          child: Text(
                            "Record Type:",
                            style: TextStyle(
                                fontSize: 0.014.sh, color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 0.42.sw,
                          padding: EdgeInsets.only(top: 0.005.sh),
                          child: Text(
                            "${details["name"]}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 0.020.sh, color: Color(0xffF08714)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.015.sh),
                          child: Text(
                            "Date:",
                            style: TextStyle(
                                fontSize: 0.014.sh, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.005.sh),
                          child: Text(
                            "${details["date"]}",
                            style: TextStyle(
                                fontSize: 0.020.sh, color: Color(0xffF08714)),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          width: 0.42.sw,
                          margin: EdgeInsets.only(
                            right: 0.03.sw,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    //fixedSize: Size(SizeConfig.blockSizeHorizontal! * 30,
                                    //  SizeConfig.blockSizeVertical! * 6),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    backgroundColor: Color(0xffFF8B6A)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PDFViewerFromUrl(
                                                url: details["fileLink"],
                                                diseaseName: details["name"],
                                              )));
                                },
                                child: Text(
                                  "View File",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 0.015.sh),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
