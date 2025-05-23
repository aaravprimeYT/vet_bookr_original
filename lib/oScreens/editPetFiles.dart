import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';

import 'addPet_screen.dart';

class EditPetFiles extends StatefulWidget {
  EditPetFiles({super.key, required this.petId, required this.details});

  String petId;

  Map<String, dynamic> details;

  @override
  State<EditPetFiles> createState() => _EditPetFilesState();
}

class _EditPetFilesState extends State<EditPetFiles> {
  final nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.details["name"];
    vaccinationController.text = widget.details["date"];
  }

  bool isLoading = false;
  bool deleteLoading = false;

  final vaccinationController = TextEditingController();

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
        extendBodyBehindAppBar: true,
        backgroundColor: kBackgroundColor,
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My Pet Details',
                    style: TextStyle(color: Color(0xffF08519), fontSize: 20.sp),
                  ),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  TextField(
                    cursorColor: Colors.black,
                    controller: nameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(color: Color(0xffFF8B6A))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(color: Color(0xffFF8B6A))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                      hintText: "Name of vaccination / disease",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.02.sh, bottom: 0.02.sh),
                    child: TextField(
                      controller: vaccinationController,
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
                                firstDate: DateTime(DateTime.now().year - 4),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value == null) {
                            return;
                          } else {
                            vaccinationController.text =
                                "${value.day}/${value.month}/${value.year}";
                          }
                        })
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Date: ",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  buttonWidget(),
                  SizedBox(height: 0.01.sh),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addPetToFireStore(Map<String, dynamic> addedPet) async {
    await FirebaseFirestore.instance
        .collection("petFiles")
        .doc(widget.details["id"])
        .update(addedPet);

    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection("petsDetails")
        .doc(widget.petId)
        .get();
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(widget.petId)
        .update({
      "petFiles": FieldValue.arrayRemove(
        snap.data()!["petFiles"]!,
      ),
    });
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(widget.petId)
        .update({
      "petFiles": FieldValue.arrayUnion(
        snap.data()!["petFiles"]!,
      ),
    });
  }

  Widget buttonWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 150,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff5EBB86),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (nameController.text == "" ||
                        vaccinationController.text == "") {
                      const snackBar = SnackBar(
                        content: Text("One of these fields is empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Map<String, dynamic> addedPetFile = {
                        "name": nameController.text,
                        "date": vaccinationController.text
                      };
                      await addPetToFireStore(addedPetFile);
                      vaccinationController.clear();
                      Navigator.pop(context);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: isLoading
                      ? Container(
                          height: 15.sp,
                          width: 15.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        )),
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF8B6A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  setState(() {
                    deleteLoading = true;
                  });
                  await FirebaseFirestore.instance
                      .collection("petsDetails")
                      .doc(widget.petId)
                      .update({
                    'petFiles': FieldValue.arrayRemove([widget.details["id"]])
                  });
                  final deleteFile = FirebaseFirestore.instance
                      .collection("petFiles")
                      .doc(widget.details["id"]);
                  await deleteFile.delete();

                  DocumentSnapshot<Map<String, dynamic>> snap =
                      await FirebaseFirestore.instance
                          .collection("petsDetails")
                          .doc(widget.petId)
                          .get();

                  await FirebaseFirestore.instance
                      .collection("petsDetails")
                      .doc(widget.petId)
                      .update({
                    'petFiles':
                        FieldValue.arrayRemove(snap.data()!["petFiles"]!),
                  });
                  await FirebaseFirestore.instance
                      .collection("petsDetails")
                      .doc(widget.petId)
                      .update({
                    'petFiles':
                        FieldValue.arrayUnion(snap.data()!["petFiles"]!),
                  });
                  Navigator.pop(context);
                },
                child: deleteLoading
                    ? Container(
                        height: 15.sp,
                        width: 15.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Delete Pet Files",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 11.2.sp),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget imageWidget(image) {
  return image != null
      ? Image.file(
          File("${image?.path}"),
          fit: BoxFit.cover,
        )
      : ElevatedButton(onPressed: () {}, child: Text(""));
}

var controllers;

controllerChanger(index) {
  if (index == 0) {
    return controllers = nameController;
  }
  if (index == 1) {
    return controllers = ageController;
  }
  if (index == 2) {
    return controllers = breedController;
  }
  if (index == 3) {
    return controllers = weightController;
  }
}

var hintText = "";

hintTextChanger(index) {
  if (index == 0) {
    return hintText = "Name Of Vaccination/Disease";
  }
  if (index == 1) {
    return hintText = "Age: ";
  }
  if (index == 2) {
    return hintText = "Breed: ";
  }
  if (index == 3) {
    return hintText = "Weight: ";
  }
}
