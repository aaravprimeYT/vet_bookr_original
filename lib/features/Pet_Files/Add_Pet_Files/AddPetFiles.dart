import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Files/Add_Pet_Files/Add_Pet_Files_Controller.dart';

import '../../Add_Pet/Add_Pet_Home/addPet_screen.dart';

class AddPetFiles extends StatefulWidget {
  AddPetFiles({super.key, required this.petId});

  String petId;
  List<XFile> images = [];

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
          title: Padding(
            padding: EdgeInsets.only(left: 0.175.sw),
            child: Text(
              'Add a record',
              style: TextStyle(color: Color(0xffF19232), fontSize: 20.sp),
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
        ),
        backgroundColor: kBackgroundColor,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 0.025.sh,
                  ),
                  TextField(
                    cursorColor: Colors.black,
                    controller: nameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: BorderSide(
                          color: Color(0xffFF8B6A),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                          borderSide: BorderSide(color: Color(0xffFF8B6A))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                      hintText: "Name of vaccination / disease: ",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.02.sh, bottom: 0.02.sh),
                    child: TextField(
                      controller: petFilesController.administrationController,
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
                            petFilesController.administrationController.text =
                                "${value.day}/${value.month}/${value.year}";
                          }
                        })
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                        hintText: "Administration Date: ",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.02.sh),
                    child: TextField(
                      controller: petFilesController.expiryController,
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
                                lastDate: DateTime(DateTime.now().year + 4),
                                firstDate: DateTime.now())
                            .then((value) {
                          if (value == null) {
                            return;
                          } else {
                            petFilesController.expiryController.text =
                                "${value.day}/${value.month}/${value.year}";
                          }
                        })
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
                        hintText: "Expiration Date: ",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.02.sh),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: noteController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(color: Color(0xffFF8B6A))),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 10.sp),
                        hintText: "Notes: ",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 0.015.sh),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add Files",
                      style:
                          TextStyle(fontSize: 20.sp, color: Color(0xffF19232)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.02.sh),
                    child: Row(
                      children: [
                        Container(
                          height: 0.045.sh,
                          width: 0.3.sw,
                          margin: EdgeInsets.only(right: 0.05.sw),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              backgroundColor: Color(0xffFF8B6A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.sp),
                              ),
                            ),
                            onPressed: () async {
                              imagePicker();
                              //print(widget.petId);
                              //print("will get id");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0.01.sw),
                                  child: Text(
                                    "Photo",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.045.sh,
                          width: 0.3.sw,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                backgroundColor: Color(0xffFF8B6A),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.sp))),
                            onPressed: () async {
                              _pickPDFFiles();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0.01.sw),
                                  child: Text(
                                    "Document",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.11.sh,
                    child: photos.isEmpty // If no images is selected
                        ? const SizedBox()
                        // If atleast 1 images is selected
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: photos.length,
                            itemBuilder: (BuildContext context, int index) {
                              // TO show selected file
                              return Padding(
                                padding: EdgeInsets.only(right: 0.02.sh),
                                child: Stack(
                                  children: [
                                    kIsWeb
                                        ? Image.network(photos[index].path)
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp),
                                                color: Colors.white),
                                            height: 0.11.sh,
                                            width: 0.23.sw,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.sp),
                                              child: Image.file(
                                                photos[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    Positioned(
                                      left: 65,
                                      //bottom: 0.005.sh,
                                      child: GestureDetector(
                                        onTap: () async {
                                          _removePhotos(index);
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          size: 0.07.sw,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  if (_fileNames.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 0.02.sh),
                      child: Container(
                        height: 0.11.sh,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _fileNames.length,
                          itemBuilder: (context, index) {
                            String fileName = basename(_fileNames[index].path);
                            String fileUrls = _fileNames[index].uri.toString();
                            fileUrl = fileUrls;
                            return Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 0.02.sh),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                        color: Colors.white),
                                    width: 0.23.sw,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 6.sp,
                                              left: 10.sp,
                                              right: 10.sp),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.insert_drive_file_rounded,
                                                size: 55.sp,
                                                color: Color(0xff999999),
                                              ),
                                              Text(
                                                fileName,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 12.sp,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () => _removeFile(index),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  buttonWidget(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(BuildContext context) {
    return Column(
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
                  petFilesController.isLoading = true;
                });
                if (nameController.text == "" ||
                    petFilesController.administrationController.text == "") {
                  const snackBar = SnackBar(
                    content: Text("Please enter all text fields"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MenuScreen()));
                  // vaccinationDate =
                  //     "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                  for (File photo in photos) {
                    await uploadPictures(path: photo.path, context: context);
                    //print("upload" + photo.path);
                  }

                  for (File file in _fileNames) {
                    await uploadFiles(path: file.path, context: context);
                    //print(file.path);
                  }

                  Map<String, dynamic> addedPetFile = {
                    "name": nameController.text,
                    "images": photoUrlList,
                    "files": fileUrlList,
                    "administrationDate":
                        petFilesController.administrationController.text,
                    "expiryDate": petFilesController.expiryController.text,
                    "notes": noteController.text
                  };
                  await petFilesController.addPetToFireStore(
                      addedPetFile, widget.petId);
                  nameController.clear();
                  petFilesController.administrationController.clear();
                  petFilesController.expiryController.clear();
                  noteController.clear();
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
    );
  }

  List<File> _fileNames = [];
  String photoUrl = "";
  List<String> photoUrlList = [];
  String fileUrl = "";
  List<String> fileUrlList = [];
  List<File> photos = [];

  Future<void> _pickPDFFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      List<File> pickedFiles = result.paths.map((path) => File(path!)).toList();

      setState(() {
        _fileNames = pickedFiles;
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _fileNames.removeAt(index);
    });
  }

  void _removePhotos(int index) {
    setState(() {
      photos.removeAt(index);
    });
  }

  Future<void> imagePicker() async {
    final ImagePicker _picker = ImagePicker();
    widget.images = await _picker.pickMultiImage();
    if (widget.images.isNotEmpty) {
      for (XFile image in widget.images) {
        photos.add(File(image.path));
      }
    }
    setState(() {});
  }

  final storageRef = FirebaseStorage.instance.ref();
  int index = 0;

  Future<void> uploadFiles(
      {required String path, required BuildContext context}) async {
    try {
      final fileRef = storageRef.child(
          "Users/${FirebaseAuth.instance.currentUser?.uid}/${widget.petId + index.toString()}");
      index++;
      await fileRef.putFile(File(path));
      fileUrl = await fileRef.getDownloadURL();
      fileUrlList.add(fileUrl);
      print(fileRef.getDownloadURL());
    } on FirebaseException catch (e) {
      print("File Function does work");
      SnackBar snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> uploadPictures(
      {required String path, required BuildContext context}) async {
    try {
      final pictureRef = storageRef.child(
          "Users/${FirebaseAuth.instance.currentUser?.uid}/${widget.petId + index.toString()}.jpg");
      index++;
      await pictureRef.putFile(File(path));
      photoUrl = await pictureRef.getDownloadURL();
      photoUrlList.add(photoUrl);
      print(pictureRef.getDownloadURL());
    } on FirebaseException catch (e) {
      print("Photo Function does work");
      SnackBar snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
