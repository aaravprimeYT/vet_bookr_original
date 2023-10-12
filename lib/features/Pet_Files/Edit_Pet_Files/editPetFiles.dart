import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Files/Edit_Pet_Files/Edit_Pet_Files_Controller.dart';

import '../../Add_Pet/addPet_screen.dart';

class EditPetFiles extends StatefulWidget {
  EditPetFiles({super.key, required this.petId, required this.details});

  String petId;

  Map<String, dynamic> details;

  @override
  State<EditPetFiles> createState() => _EditPetFilesState();
}

class _EditPetFilesState extends State<EditPetFiles> {
  EditPetFilesController editPetFilesController = EditPetFilesController();

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
                      controller: editPetFilesController.vaccinationController,
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
                            editPetFilesController.vaccinationController.text =
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
                      editPetFilesController.isLoading = true;
                    });
                    if (nameController.text == "" ||
                        editPetFilesController.vaccinationController.text ==
                            "") {
                      const snackBar = SnackBar(
                        content: Text("One of these fields is empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Map<String, dynamic> addedPetFile = {
                        "name": nameController.text,
                        "date":
                            editPetFilesController.vaccinationController.text
                      };
                      await editPetFilesController.addPetToFireStore(
                          addedPetFile, widget.petId, widget.details);
                      editPetFilesController.vaccinationController.clear();
                      Navigator.pop(context);
                    }
                    setState(() {
                      editPetFilesController.isLoading = false;
                    });
                  },
                  child: editPetFilesController.isLoading
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
                    editPetFilesController.deleteLoading = true;
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
                child: editPetFilesController.deleteLoading
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
