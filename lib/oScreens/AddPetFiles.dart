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

import 'addPet_screen.dart';

class AddPetFiles extends StatefulWidget {
  AddPetFiles({super.key, required this.petId});

  String petId;

  @override
  State<AddPetFiles> createState() => _AddPetFilesState();
}

class _AddPetFilesState extends State<AddPetFiles> {
  DateTime selectedDate = DateTime.now();
  final nameController = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  List<Prescription> prescArray = [];

  bool isLoading = false;

  final vaccinationController = TextEditingController();

  bool noImage = true;

  File? pdfFile;
  final storageRef = FirebaseStorage.instance.ref();

  var petId = DateTime.now().millisecondsSinceEpoch.toString();

  String imageUrl = "";
  List<String> imageUrlList = [];
  int index = 0;
  Future<void> uploadImages(
      {required String path, required String name}) async {
    try {
      final imageRef = storageRef.child(
          "Users/${FirebaseAuth.instance.currentUser?.uid}/$petId$index");
      index++;
      await imageRef.putFile(File(path));
      imageUrl = await imageRef.getDownloadURL();
      imageUrlList.add(imageUrl);
      setState(() {});
      print(imageRef.getDownloadURL());
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
                  Text(
                      files.isNotEmpty ? "Image Selected" : "No Image Selected")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addPetToFireStore(Map<String, dynamic> addedPet) async {
    var doc = FirebaseFirestore.instance.collection("petFiles").doc();
    await FirebaseFirestore.instance
        .collection("petFiles")
        .doc(doc.id)
        .set(addedPet);
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(widget.petId)
        .update({
      "petFiles": FieldValue.arrayUnion([doc.id])
    });
  }

  List<File> files = [];

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
                      padding: EdgeInsets.zero,
                      backgroundColor: Color(0xffFF8B6A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    List<XFile> images = await _picker.pickMultiImage();
                    if (images.isNotEmpty) {
                      for (XFile image in images) {
                        files.add(File(image.path));
                      }
                    }
                    setState(() {});
                  },
                  child: Text(
                    "Upload Records",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
                  )),
            ),
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
                        vaccinationController.text == "" ||
                        files.length == 0) {
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
                      for (File file in files) {
                        await uploadImages(path: file.path, name: petName);
                      }

                      Map<String, dynamic> addedPetFile = {
                        "name": nameController.text,
                        "files": imageUrlList,
                        "date": vaccinationController.text
                      };
                      addPetToFireStore(addedPetFile);
                      nameController.clear();
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
                          "Submit",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        )),
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
