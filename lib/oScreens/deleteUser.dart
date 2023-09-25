import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Welcome_Page/welcome_screen.dart';
import 'package:vet_bookr/oScreens/list_pet.dart';

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
      User user = _auth.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);

      if (result.user != null) {
        await result.user!.delete();
      }
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                  context, MaterialPageRoute(builder: (context) => ListPets()));
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
              padding:
                  EdgeInsets.only(top: 0.1.sh, left: 0.1.sw, right: 0.1.sw),
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
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.01.sh),
              child: SizedBox(
                width: 0.9.sw,
                height: 40.sp,
                child: TextFormField(
                  cursorColor: Colors.black,
                  obscureText: true,
                  style: TextStyle(fontSize: 0.017.sh),
                  controller: passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide(color: Color(0xffFF8B6A))),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0.01.sh, horizontal: 0.03.sw),
                    hintStyle: TextStyle(fontSize: 0.017.sh),
                    hintText: "Password",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffFF8B6A)),
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.03.sh,
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.05.sw),
              child: Text(
                "Please know that this action is irreversible.",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 0.03.sh,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF8B6A)),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  print(
                      "delete started -------------------------------------------------");
                  final petsDetails = FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get();
                  final petFiles = FirebaseFirestore.instance
                      .collection("petsDetails")
                      .doc()
                      .get();
                  print(
                      "delete halfway -------------------------------------------------");

                  //print(petFiles);
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
                      print(
                          "delete 75% -------------------------------------------------");

                      await FirebaseFirestore.instance
                          .collection("petsDetails")
                          .doc(petId)
                          .update({
                        'petFiles': FieldValue.arrayRemove([petFileId])
                      });
                      final deleteFile = FirebaseFirestore.instance
                          .collection("petFiles")
                          .doc(petFileId);
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

                  await deleteUser(
                      emailController.text, passwordController.text);

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
                          color: Colors.white,
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
      ),
    );
  }
}
