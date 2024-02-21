import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_bookr/features/Pet_Files/Add_Pet_Files/AddPetFiles.dart';
import 'package:vet_bookr/features/Pet_Files/File_UI/File_UI_Controller.dart';

import '../constant.dart';
import '../features/Pet_Files/petFiles.dart';

class ShowPet extends StatefulWidget {
  ShowPet({Key? key, required this.details}) : super(key: key);

  Map<String, dynamic> details;

  @override
  State<ShowPet> createState() => _ShowPetState();
}

class _ShowPetState extends State<ShowPet> {
  FileUIController fileUIController = FileUIController();
  List<String> labels = ["Name", "Age", "Breed", "Weight"];
  bool editableText = false;
  bool showRecord = true;
  bool showProfile = false;
  String imageUrl = "";
  Color profileButton = Colors.transparent;
  Color recordButton = Color(0xff75C3F4);
  bool isLoading = false;
  FontWeight profileFont = FontWeight.w400;
  FontWeight recordFont = FontWeight.bold;

  Widget backgroundChanger() {
    if (showRecord == true) {
      print(showRecord);
      return recordWidget();
    } else if (showProfile == true) {
      //print(showProfile);
      return profileWidget();
    }
    return Text("wait");
  }

  @override
  void initState() {
    getPetFiles();
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
          title: Padding(
            padding: EdgeInsets.only(left: 0.175.sw),
            child: Text(
              "${widget.details["name"]}'s Details",
              style: TextStyle(color: Color(0xffF08519), fontSize: 0.05.sw),
            ),
          ),
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

                      final ref = storageRef.child(
                          "Users/${FirebaseAuth.instance.currentUser?.uid}/${widget.details["id"]}");
                      await ref.delete();
                      await FirebaseFirestore.instance
                          .collection("petsDetails")
                          .doc(widget.details["id"])
                          .delete();
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({
                        'pets': FieldValue.arrayRemove([widget.details["id"]]),
                      });

                      DocumentSnapshot<Map<dynamic, dynamic>> snap =
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
                      padding: EdgeInsets.only(bottom: 15.sp),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // sBox(h: 10),
                            //      myPetTile()
                            SizedBox(
                              height: 0.015.sh,
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 0.15.sh,
                                  width: 0.15.sh,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Color(0xffFF8B6A),
                                  ),
                                  child: profilePic == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.sp),
                                          child: Image.network(
                                            widget.details["profilePicture"],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.sp),
                                          child: Image.file(
                                            File(
                                              "${profilePic?.path}",
                                            ),
                                          ),
                                        ),
                                ),
                                editableText
                                    ? Positioned(
                                        right: 0.01.sw,
                                        bottom: 0.005.sh,
                                        child: GestureDetector(
                                          onTap: () async {
                                            profilePic = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery);
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
                              height: 0.025.sh,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showRecord = true;
                                      showProfile = false;
                                      profileButton = Colors.transparent;
                                      recordButton = Color(0xff75C3F4);
                                      recordFont = FontWeight.bold;
                                      profileFont = FontWeight.w400;
                                    });
                                  },
                                  child: Stack(children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 0.5.sw,
                                      child: Text(
                                        'Records',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.sp,
                                            fontWeight: recordFont),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0.15.sw,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.sp),
                                            color: recordButton),
                                        width: 0.2.sw,
                                        height: 2,
                                      ),
                                    ),
                                  ]),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(recordButton);
                                    print(profileButton);
                                    setState(() {
                                      showRecord = false;
                                      showProfile = true;
                                      recordButton = Colors.transparent;
                                      profileButton = Color(0xff75C3F4);
                                      profileFont = FontWeight.bold;
                                      recordFont = FontWeight.w400;
                                    });
                                  },
                                  child: Stack(children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 0.5.sw,
                                      child: Text(
                                        'Profile',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.sp,
                                            fontWeight: profileFont),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0.15.sw,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.sp),
                                            color: profileButton),
                                        width: 0.2.sw,
                                        height: 2,
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Container(
                              width: 1.sw,
                              height: 1,
                              color: Color(0xff75C3F4).withOpacity(0.3),
                            ),
                            backgroundChanger(),
                          ]),
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
              child: FloatingActionButton.extended(
                label: isLoadingEdit
                    ? Container(
                        height: 15.sp,
                        width: 15.sp,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.sp,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            editableText ? "Save Changes" : "Add Records",
                            style: TextStyle(
                                color: Colors.white, fontSize: 0.03.sw),
                          ),
                        ],
                      ),
                backgroundColor: Color(0xffFF8B6A),
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
                    DocumentSnapshot<Map<String, dynamic>> snap =
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get();

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update({
                      'pets': FieldValue.arrayRemove(snap.data()!["pets"]!)
                    });

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
                    Navigator.pop(context);
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
                        builder: (context) =>
                            AddPetFiles(petId: widget.details["id"]),
                      ),
                    ).then((value) => getPetFiles());
                  }
                },
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

  Widget profileWidget() {
    return Column(
      children: [
        ...List.generate(
          4,
          (index) => Padding(
            padding:
                EdgeInsets.only(top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
            child: TextField(
              enabled: editableText,
              controller: controllerChanger(index),
              style: TextStyle(fontSize: 0.017.sh),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                label: Text(labels[index], style: TextStyle(fontSize: 0.02.sh)),
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
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 0.02.sh, left: 0.05.sw, right: 0.05.sw, bottom: 0.02.sh),
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
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: Color(0xffFF8B6A), // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 4),
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
                text: "${widget.details["lastVaccinationDate"]}"),
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
                  borderSide: BorderSide(color: Color(0xffFF8B6A))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: BorderSide(color: Color(0xffFF8B6A))),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget recordWidget() {
    return isLoading
        ? Container(
            height: 15.sp,
            width: 15.sp,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.sp,
            ),
          )
        : Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: petFileDetails.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.015.sh),
                        child: Container(
                          height: 140.sp,
                          width: 0.9.sw,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.01.sh, left: 0.03.sw),
                                    child: Text(
                                      petFileDetails[index]['name'],
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.01.sh, right: 0.01.sw),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.015.sh),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 0.03.sw),
                                          child: Text(
                                            "Administration Date: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              color: Color(0xff5D5D5D),
                                            ),
                                          ),
                                        ),
                                        Text(petFileDetails[index]
                                                ["administrationDate"] ??
                                            "No Administration Date")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.006.sh),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 0.03.sw),
                                          child: Text(
                                            "Expiry Date: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              color: Color(0xff5D5D5D),
                                            ),
                                          ),
                                        ),
                                        Text(petFileDetails[index]
                                                ["expiryDate"] ??
                                            "No Expiry Date")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.006.sh),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 0.03.sw),
                                          child: Text(
                                            "Notes: ",
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              color: Color(0xff5D5D5D),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 16,
                                          width: 0.7.sw,
                                          child: Text(
                                            petFileDetails[index]["notes"] ??
                                                "No Notes",
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.015.sh),
                                child: Container(
                                  width: 0.88.sw,
                                  height: 0.03.sh,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Color(0xff7FC3F4),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.sp))),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PetFiles(
                                              petFileDetails:
                                                  petFileDetails[index]),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View Record",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      //Text(petFileDetails[index]['expiryDate'])
                    ],
                  );
                },
              ),
              buttonWidget(),
            ],
          );
  }

  List<Map<String, dynamic>> petFileDetails = [];

  Future<void> getPetFiles() async {
    petFileDetails = [];
    setState(() {
      isLoading = true;
    });
    // 1. Get the ids
    DocumentSnapshot<Map<String, dynamic>> petDoc = await FirebaseFirestore
        .instance
        .collection("petsDetails")
        .doc(widget.details['id'])
        .get();
    List<dynamic> petFileIds = petDoc.data()!['petFiles'];
    // 2. Loop through the ids
    for (String fileId in petFileIds) {
      DocumentSnapshot<Map<String, dynamic>> fileDetails =
          await FirebaseFirestore.instance
              .collection("petFiles")
              .doc(fileId)
              .get();
      if (fileDetails.data() != null) {
        petFileDetails.add(fileDetails.data()!);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  //call expiryDateChecker in recordWidget
  //if expiryDateChecker = true, display the date, else say text
  //if function is made with string changer, where to call function

  //if file does not have expiryDate, dont show expiry date
  Future<bool> expiryDateChecker(index) async {
    print(petFileDetails[index].containsKey("expiryDate"));
    return petFileDetails[index].containsKey("expiryDate");
  }
}
