import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';

import '../oScreens/addPet_screen.dart';
import '../oScreens/list_ui.dart';

class ListPets extends StatefulWidget {
  @override
  State<ListPets> createState() => _ListPetsState();
}

// final Stream<QuerySnapshot> _usersStream =
//     FirebaseFirestore.instance.collection('petsDetails').snapshots();

@override
class _ListPetsState extends State<ListPets> {
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
            MaterialPageRoute(builder: (context) => AddPetHome()),
          );
        },
        backgroundColor: Color(0xffFF8B6A),
        label: Text(
          "Add Pet",
          style: TextStyle(fontSize: 0.03.sw),
        ),
        icon: Icon(Icons.add, size: 0.05.sw),
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
                "My Pet(s)",
                style: TextStyle(color: Color(0xffDD8229), fontSize: 0.05.sw),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      var pets = snapshot.data?.data()!["pets"];
                      if (pets.length == 0) {
                        return Container(
                          height: 0.4.sh,
                          width: 1.sw,
                          child: Center(
                            child: Text(
                              "Please Add Your Pet",
                              style: TextStyle(
                                fontSize: 0.024.sh,
                              ),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ListUI(id: pets[index]);
                        },
                        itemCount: pets.length,
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
