import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/prescription.dart';

class AddPetHome extends StatefulWidget {
  const AddPetHome({super.key});

  @override
  State<AddPetHome> createState() => _AddPetHomeState();
}

String petName = "";
int petAge = 0;
double petWeight = 0;
String petBreed = "";
String vaccinationDate = "";

final nameController = TextEditingController();
final ageController = TextEditingController();
final breedController = TextEditingController();
final weightController = TextEditingController();

class _AddPetHomeState extends State<AddPetHome> {
  DateTime selectedDate = DateTime.now();

  List<Prescription> prescArray = [];

  bool isLoading = false;

  final vaccinationController = TextEditingController();

  bool noImage = true;

  XFile? profilePic;
  ImagePicker imagePicker = ImagePicker();

  final storageRef = FirebaseStorage.instance.ref();

  String imageUrl = "";

  Future<void> uploadImages({required String path, required String id}) async {
    try {
      final imageRef = storageRef
          .child("Users/${FirebaseAuth.instance.currentUser?.uid}/$id");
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
                  // sBox(h: 10),
                  Text(
                    'My Pet Details',
                    style: TextStyle(
                      color: Color(0xffF08519),
                      fontSize: 0.05.sw,
                    ),
                  ),
                  //      myPetTile()
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      profilePic = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 75.sp,
                      backgroundColor: Color(0xffFF8B6A),
                      child: profilePic == null
                          ? Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text(
                                "Click here to add a profile picture for your pet",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                height: 0.7.sh,
                                width: 0.7.sh,
                                child: Image.file(
                                  fit: BoxFit.cover,
                                  File(
                                    "${profilePic?.path}",
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                          top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                      child: TextField(
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 0.017.sh),
                        controller: controllerChanger(index),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.sp),
                          hintText: hintTextChanger(index),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 0.017.sh),
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
                        controller: vaccinationController,
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
                                  vaccinationController.text =
                                      "${value.day}/${value.month}/${value.year}";
                                }
                              })
                            },
                        readOnly: true,
                        style: TextStyle(fontSize: 0.017.sh),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.03.sw,
                          ),
                          hintText: "Last Vaccination Date ",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 0.017.sh),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (name) {
                          setState(() {
                            vaccinationDate = vaccinationController as String;
                          });
                        }),
                  ),
                  buttonWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addPetToFireStore(Map<String, dynamic> addedPet) async {
    var doc = FirebaseFirestore.instance.collection("petDetails").doc();
    addedPet.update("id", (value) => doc.id);
    await uploadImages(path: profilePic!.path, id: doc.id);
    addedPet.update("profilePicture", (value) => imageUrl);

    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(doc.id)
        .set(addedPet);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "pets": FieldValue.arrayUnion([doc.id])
    });
  }

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
                    backgroundColor: Color(0xff5EBB86),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  onPressed: () async {
                    bool isEmpty = false;

                    for (var i = 0; i < 4; i++) {
                      if (controllerChanger(i).text == "") {
                        isEmpty = true;
                        break;
                      }
                    }

                    setState(() {
                      isLoading = true;
                    });
                    if (isEmpty ||
                        vaccinationController.text == "" ||
                        profilePic?.path == null) {
                      const snackBar = SnackBar(
                        content: Text("One of these fields is empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MenuScreen()));
                      // vaccinationDate =
                      //     "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";

                      Map<String, dynamic> addedPet = {
                        "name": controllerChanger(0).text,
                        "age": controllerChanger(1).text,
                        "weight": controllerChanger(3).text,
                        "breed": controllerChanger(2).text,
                        "profilePicture": imageUrl,
                        "id": "",
                        "petFiles": [],
                        "lastVaccinationDate": vaccinationController.text
                      };
                      await addPetToFireStore(addedPet);
                      for (var i = 0; i < 4; i++) {
                        controllerChanger(i).clear();
                      }
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
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 0.03.sw,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
            ),
          ],
        ),
      ],
    );
  }

  void myPrescription(List<Prescription> prescriptionArray) {
    prescArray = prescriptionArray;
    print(prescArray.length);
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
    return hintText = "Name ";
  }
  if (index == 1) {
    return hintText = "Age (Years, Months) ";
  }
  if (index == 2) {
    return hintText = "Breed ";
  }
  if (index == 3) {
    return hintText = "Weight (Kg) ";
  }
}

var variableText;

// variableChanger(index, value) {
//   if (index == 0) {
//     return petName = value;
//   }
//   if (index == 1) {
//     return petAge = value;
//   }
//   if (index == 2) {
//     return petBreed = value;
//   }
//   if (index == 3) {
//     return petWeight = value;
//   }
// }
