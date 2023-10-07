import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Files/Add_Pet_Files/AddPetFiles.dart';

import 'fileUI.dart';

class PetFiles extends StatefulWidget {
  PetFiles({super.key, required this.petId});

  String petId;

  @override
  State<PetFiles> createState() => _PetFilesState();
}

// final Stream<QuerySnapshot> _usersStream =
//     FirebaseFirestore.instance.collection('petsDetails').snapshots();

@override
class _PetFilesState extends State<PetFiles> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPetFiles(petId: widget.petId)),
          );
        },
        backgroundColor: Color(0xffFF8B6A),
        label: Text(
          "Add Pet Files",
          style: TextStyle(fontSize: 0.03.sw),
        ),
        icon: Icon(
          Icons.add,
          size: 0.05.sw,
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: kBackgroundColor,
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
      body: Container(
        height: h,
        width: w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "My Pet's Health Records",
                style: TextStyle(color: Color(0xffF08714), fontSize: 0.05.sw),
              ),
              SizedBox(
                height: 0.05.sh,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("petsDetails")
                      .doc(widget.petId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data?.data()!["profilePicture"]);
                      List<dynamic> petFiles =
                          snapshot.data?.data()!["petFiles"];
                      print(petFiles);
                      if (petFiles.length == 0) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
                          height: 0.4.sh,
                          width: 1.sw,
                          child: Center(
                            child: Text(
                              "Please add your pet's \n vaccination/disease files",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 0.024.sh,
                              ),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return FileUI(
                            id: petFiles[index],
                            petId: widget.petId,
                          );
                        },
                        itemCount: petFiles.length,
                        shrinkWrap: true,
                      );
                    }
                    return Container(
                      width: 1.sw,
                      height: 0.4.sh,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15.sp,
                            width: 15.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xffFF8B6A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
//
