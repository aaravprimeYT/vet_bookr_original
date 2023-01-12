import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/prescription.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import 'addPet_screen.dart';

class AddPetFiles extends StatefulWidget {
  AddPetFiles({super.key, required this.petId});

  String petId;

  @override
  State<AddPetFiles> createState() => _AddPetFilesState();
}

final nameController = TextEditingController();

class _AddPetFilesState extends State<AddPetFiles> {
  DateTime selectedDate = DateTime.now();

  List<Prescription> prescArray = [];

  bool isLoading = false;

  final vaccinationController = TextEditingController();

  bool noImage = true;

  File? pdfFile;
  final storageRef = FirebaseStorage.instance.ref();

  var petId = DateTime.now().millisecondsSinceEpoch.toString();

  String imageUrl = "";

  Future<void> uploadImages(
      {required String path, required String name}) async {
    try {
      final imageRef = storageRef
          .child("Users/${FirebaseAuth.instance.currentUser?.uid}/$petId");
      await imageRef.putFile(File(path));
      imageUrl = await imageRef.getDownloadURL();
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
    return Scaffold(
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
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
                Text(pdfFile == null ? "No File Selected" : "File Selected")
              ],
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

  Widget buttonWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF8B6A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    setState(() {
                      pdfFile = File(result.files.single.path!);
                    });
                  }
                },
                child: Text("Upload Pet Files")),
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
                        pdfFile?.path == null) {
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
                      await uploadImages(path: pdfFile!.path!, name: petName);

                      Map<String, dynamic> addedPetFile = {
                        "name": controllerChanger(0).text,
                        "fileLink": imageUrl,
                        "date": vaccinationController.text
                      };
                      addPetToFireStore(addedPetFile);
                      controllerChanger(0).clear();
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
                              fontSize: 15.sp, fontWeight: FontWeight.w400),
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
