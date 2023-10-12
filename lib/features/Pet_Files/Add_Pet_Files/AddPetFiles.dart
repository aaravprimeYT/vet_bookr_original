import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Files/Add_Pet_Files/Add_Pet_Files_Controller.dart';

import '../../Add_Pet/addPet_screen.dart';

class AddPetFiles extends StatefulWidget {
  AddPetFiles({super.key, required this.petId});

  String petId;

  @override
  State<AddPetFiles> createState() => _AddPetFilesState();
}

class _AddPetFilesState extends State<AddPetFiles> {
  PetFilesController petFilesController = PetFilesController();

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
                      controller: petFilesController.vaccinationController,
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
                            petFilesController.vaccinationController.text =
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
                      petFilesController.isLoading = true;
                    });
                    if (nameController.text == "" ||
                        petFilesController.vaccinationController.text == "" ||
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
                        await petFilesController.uploadImages(
                            path: file.path, name: petName, context: context);
                      }

                      Map<String, dynamic> addedPetFile = {
                        "name": nameController.text,
                        "files": petFilesController.imageUrlList,
                        "date": petFilesController.vaccinationController.text
                      };
                      petFilesController.addPetToFireStore(addedPetFile);
                      nameController.clear();
                      petFilesController.vaccinationController.clear();
                      Navigator.pop(context);
                    }
                    setState(() {
                      petFilesController.isLoading = false;
                    });
                  },
                  child: petFilesController.isLoading
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
