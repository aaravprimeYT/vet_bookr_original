import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
  bool editableText = false;

  String imageUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.details["name"];
    ageController.text = widget.details["age"];
    breedController.text = widget.details["breed"];
    weightController.text = widget.details["weight"];

    super.initState();
  }

  Future<void> uploadImages({required String path}) async {
    try {
      final imageRef = storageRef.child(
          "Users/${FirebaseAuth.instance.currentUser?.uid}/${widget.details["id"]}");
      await imageRef.putFile(File(path));
      imageUrl = await imageRef.getDownloadURL();
      setState(() {});
      //print(imageRef.getDownloadURL());
    } on FirebaseException catch (e) {
      print("Function does work");
      SnackBar snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool isLoading = false;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final breedController = TextEditingController();
  final weightController = TextEditingController();

  XFile? profilePic;
  ImagePicker imagePicker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();

  TextEditingController controllerChanger(index) {
    if (index == 0) {
      return nameController;
    }
    if (index == 1) {
      return ageController;
    }
    if (index == 2) {
      return breedController;
    }
    if (index == 3) {
      return weightController;
    }
    return TextEditingController();
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
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 5.sp),
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Edit Pet"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Delete Pet"),
                      ),
                    ];
                  },
                  onSelected: (value) async {
                    if (value == 0) {
                      setState(() {
                        editableText = true;
                      });
                      print(editableText);
                    } else if (value == 1) {
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({
                        'pets': FieldValue.arrayRemove([widget.details["id"]])
                      });
                      final ref = storageRef.child(
                          "Users/${FirebaseAuth.instance.currentUser?.uid}/${widget.details["id"]}");
                      await ref.delete();
                      await FirebaseFirestore.instance
                          .collection("petsDetails")
                          .doc(widget.details["id"])
                          .delete();

                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    }
                  },
                ))
          ],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: kBackgroundColor,
        body: isLoading
            ? Container(
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
              )
            : SafeArea(
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
                            style: TextStyle(
                                color: Color(0xffF08519), fontSize: 0.05.sw),
                          ),
                          //      myPetTile()
                          SizedBox(
                            height: 0.05.sh,
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 0.095.sh,
                                backgroundColor: Color(0xffFF8B6A),
                                backgroundImage: profilePic == null
                                    ? NetworkImage(
                                        widget.details["profilePicture"],
                                      )
                                    : null,
                                child: profilePic == null
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          File(
                                            "${profilePic?.path}",
                                          ),
                                        ),
                                      ),
                              ),
                              editableText
                                  ? Positioned(
                                      right: 0.025.sw,
                                      bottom: 0.005.sh,
                                      child: GestureDetector(
                                        onTap: () async {
                                          profilePic = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          setState(() {});
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xffFF8B6A),
                                          radius: 0.02.sh,
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 0.05.sw,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          ...List.generate(
                            4,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                              child: TextField(
                                enabled: editableText,
                                controller: controllerChanger(index),
                                style: TextStyle(fontSize: 0.017.sh),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  label: Text(labels[index],
                                      style: TextStyle(fontSize: 0.02.sh)),
                                  labelStyle: TextStyle(color: Colors.black54),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      borderSide:
                                          BorderSide(color: Color(0xffFF8B6A))),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      borderSide:
                                          BorderSide(color: Color(0xffFF8B6A))),
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
                              enabled: editableText,
                              onTap: () => {
                                showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Color(0xffFF8B6A),
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  primary: Color(
                                                      0xffFF8B6A), // button text color
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().year - 4),
                                        lastDate: DateTime.now())
                                    .then((value) {
                                  if (value == null) {
                                    return;
                                  } else {
                                    setState(() {
                                      widget.details["lastVaccinationDate"] =
                                          "${value.day}/${value.month}/${value.year}";
                                    });
                                  }
                                })
                              },
                              controller: TextEditingController(
                                  text:
                                      "${widget.details["lastVaccinationDate"]}"),
                              readOnly: true,
                              style: TextStyle(fontSize: 0.017.sh),
                              decoration: InputDecoration(
                                label: Text("Last Vaccination Date",
                                    style: TextStyle(fontSize: 0.02.sh)),
                                labelStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    borderSide:
                                        BorderSide(color: Color(0xffFF8B6A))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    borderSide:
                                        BorderSide(color: Color(0xffFF8B6A))),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                              ),
                            ),
                          ),
                          buttonWidget()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  bool isLoadingEdit = false;

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
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                ),
                onPressed: () async {
                  if (editableText) {
                    setState(() {
                      isLoadingEdit = true;
                    });
                    if (profilePic != null) {
                      final ref = storageRef.child(
                          "Users/${FirebaseAuth.instance.currentUser?.uid}/${widget.details["id"]}");
                      await ref.delete();
                      await uploadImages(path: profilePic!.path);
                    }
                    await FirebaseFirestore.instance
                        .collection("petsDetails")
                        .doc(widget.details["id"])
                        .update({
                      'name': nameController.text,
                      'age': ageController.text,
                      'breed': breedController.text,
                      'weight': weightController.text,
                      'profilePicture': profilePic != null
                          ? imageUrl
                          : widget.details["profilePicture"],
                      'lastVaccinationDate':
                          widget.details["lastVaccinationDate"]
                    });
                    List<String> petIds = [];
                    DocumentSnapshot<Map<String, dynamic>> snap =
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get();

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update({
                      'pets': FieldValue.arrayRemove(snap.data()!["pets"]!),
                    });
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update({
                      'pets': FieldValue.arrayUnion(snap.data()!["pets"]!),
                    });
                    setState(() {
                      isLoadingEdit = false;
                      editableText = false;
                    });
                    const snackBar = SnackBar(
                      content: Text("Your pet's details have been changed"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetFiles(
                          petId: widget.details["id"],
                        ),
                      ),
                    );
                  }
                },
                child: isLoadingEdit
                    ? Container(
                        height: 15.sp,
                        width: 15.sp,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.sp,
                        ),
                      )
                    : Text(
                        editableText ? "Save Changes" : "Pet Health Records",
                        style:
                            TextStyle(color: Colors.white, fontSize: 0.03.sw),
                      ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.01.sh,
        ),
      ],
    );
  }
}
