import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/oScreens/showPdf.dart';

import 'editPetFiles.dart';

class FileUI extends StatefulWidget {
  FileUI({Key? key, required this.id, required this.petId}) : super(key: key);

  String id;

  String petId;

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
    details = petDetails.data()!;
    details.putIfAbsent("id", () => widget.id);
    setState(() {
      isLoading = false;
    });
    print(petDetails.data());
  }

  late Map<String, dynamic> petDetails;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              width: 0.07.sw,
                              height: 0.07.sw,
                              child: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Text("Edit Record"),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Text("Delete Record"),
                                    ),
                                  ];
                                },
                                onSelected: (value) async {
                                  if (value == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPetFiles(
                                          petId: widget.petId,
                                          details: details,
                                        ),
                                      ),
                                    );
                                  }
                                  if (value == 1) {
                                    await FirebaseFirestore.instance
                                        .collection("petsDetails")
                                        .doc(widget.petId)
                                        .update({
                                      'petFiles':
                                          FieldValue.arrayRemove([widget.id])
                                    });
                                    final deleteFile = FirebaseFirestore
                                        .instance
                                        .collection("petFiles")
                                        .doc(widget.id);
                                    await deleteFile.delete();
                                  }
                                },
                              ),
                            )
                          ],
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
                                      builder: (context) => ImageViewer(
                                        urls: details["files"],
                                        diseaseName: details["name"],
                                      ),
                                    ),
                                  );
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
