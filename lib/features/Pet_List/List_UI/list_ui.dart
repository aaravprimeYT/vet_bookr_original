import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/oScreens/showPetScreen.dart';

class ListUI extends StatefulWidget {
  ListUI({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<ListUI> createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {
  bool isLoading = true;
  late Map<String, dynamic> details;

  Future<void> getPetDetails(String id) async {
    DocumentSnapshot<Map<String, dynamic>> petDetails = await FirebaseFirestore
        .instance
        .collection("petsDetails")
        .doc(id)
        .get();
    setState(() {
      details = petDetails.data()!;
    });
  }

  @override
  void initState() {
    initializeListUi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeListUi() async {
    setState(() {
      isLoading = true;
    });
    await getPetDetails(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            padding: EdgeInsets.all(75.sp),
            child: CircularProgressIndicator(
              color: Color(0xffFF8B6A),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowPet(details: details)));
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
                        radius: 44.sp,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.01.sh),
                      child: Text(
                        "${details["name"]}",
                        style: TextStyle(
                            fontSize: 0.05.sw, color: Color(0xffF08714)),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Container(
                        width: 0.45.sw,
                        padding: EdgeInsets.only(
                          top: 0.01.sh,
                        ),
                        child: Text(
                          "${details["breed"]}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 0.04.sw),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
