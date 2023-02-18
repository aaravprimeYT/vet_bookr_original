import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/oScreens/menu_screen.dart';
import 'package:vet_bookr/oScreens/welcome_screen.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({Key? key}) : super(key: key);

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  @override
  void initState() {
    // TODO: implement initState
    emailController.text = FirebaseAuth.instance.currentUser!.email.toString();
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future deleteUser(String email, String password) async {
    try {
      var user = await _auth.currentUser!;
      await FirebaseAuth.instance.currentUser
          ?.delete(); // called from database class
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuScreen()));
          },
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.05.sh),
            child: Text(
              'Delete User',
              style: TextStyle(color: Color(0xffF08519), fontSize: 0.05.sw),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.1.sh, left: 0.1.sw, right: 0.1.sw),
            child: SizedBox(
              width: 0.9.sw,
              height: 40.sp,
              child: TextFormField(
                cursorColor: Colors.black,
                style: TextStyle(fontSize: 0.017.sh),
                controller: emailController,
                enabled: false,
                decoration: InputDecoration(
                  label: Text("Your Email is: ",
                      style: TextStyle(fontSize: 0.02.sh)),
                  labelStyle: TextStyle(color: Colors.black54),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(color: Color(0xffFF8B6A))),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                      borderSide: BorderSide(color: Color(0xffFF8B6A))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0.03.sh,
          ),
          Text(
            "Please know that this action is irreversible.",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 0.03.sh,
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xffFF8B6A)),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                deleteUser(emailController.text, passwordController.text);
                final petsDetails = FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get();
                print(petsDetails);

                final petFiles = FirebaseFirestore.instance
                    .collection("petsDetails")
                    .doc()
                    .get();

                print(petFiles);
                print("Delete first");
                var userDetails = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
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
                      'petFiles':
                          FieldValue.arrayRemove([fileDetails.data()!["id"]])
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
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'pets': FieldValue.arrayRemove([petId]),
                  });
                }
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .delete();
                print("Firestore deleted first");
                // await FirebaseAuth.instance.signOut();
                await FirebaseAuth.instance.currentUser?.delete();
                // setState(() {
                //   isLoading = false;
                // });

                setState(() {
                  isLoading = false;
                });

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
              child: isLoading
                  ? Container(
                      height: 2.sp,
                      width: 2.sp,
                      child: CircularProgressIndicator(
                        color: Color(0xffFF8B6A),
                        strokeWidth: 2.sp,
                      ),
                    )
                  : Text(
                      "Delete User",
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ))
        ],
      ),
    );
  }
}
