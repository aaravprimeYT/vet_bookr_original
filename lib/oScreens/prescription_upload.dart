import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_bookr/oScreens/addPet_screen.dart';
import '../models/prescription.dart';

class PrescriptionUpload extends StatefulWidget {
  final Function(List<Prescription> prescriptions) callBack;
  const PrescriptionUpload({super.key, required this.callBack});

  @override
  State<PrescriptionUpload> createState() => _PrescriptionUploadState();
}

final controller1 = TextEditingController();
final controller2 = TextEditingController();
final controller3 = TextEditingController();
final controller4 = TextEditingController();
final controller5 = TextEditingController();
final controller6 = TextEditingController();

class _PrescriptionUploadState extends State<PrescriptionUpload> {
  XFile? image1;
  XFile? image2;
  XFile? image3;
  XFile? image4;
  XFile? image5;
  XFile? image6;

  List<Prescription> prescArray = [];




  ImagePicker imagePicker = ImagePicker();



  final storageRef = FirebaseStorage.instance.ref();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAEDE1),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 50.0,
              ),
              child: Text(
                "My Pet Health Records",
                style: TextStyle(color: Color(0xffDD8229), fontSize: 24),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF8B6A),
              ),
              onPressed: () {
                for (var i = 0; i < 6; i++) {
                  prescArray.removeWhere((element) {
                    return element.tag == i;
                  });
                  if (i == 0 && image1 != null) {
                    var prescription = Prescription(
                        "${controller1.text}", "${image1?.path}", i);
                    prescArray.add(prescription);
                  }
                  if (i == 1 && image2 != null) {
                    var prescription = Prescription(
                        "${controller2.text}", "${image2?.path}", i);
                    prescArray.add(prescription);
                  }
                  if (i == 2 && image3 != null) {
                    var prescription = Prescription(
                        "${controller3.text}", "${image3?.path}", i);
                    prescArray.add(prescription);
                  }
                  if (i == 3 && image4 != null) {
                    var prescription = Prescription(
                        "${controller4.text}", "${image4?.path}", i);
                    prescArray.add(prescription);
                  }
                  if (i == 4 && image5 != null) {
                    var prescription = Prescription(
                        "${controller5.text}", "${image5?.path}", i);
                    prescArray.add(prescription);
                  }
                  if (i == 5 && image6 != null) {
                    var prescription = Prescription(
                        "${controller6.text}", "${image6?.path}", i);
                    prescArray.add(prescription);
                  }
                }
                widget.callBack(prescArray);
                Navigator.pop(context);
              },
              child: Text("Done"),),
            SizedBox(
              height: 10,
            ),
            Text(
              "Name the file as the type of immunization and date for\neasy reference",
              style: TextStyle(
                  fontWeight: FontWeight.w400, color: Color(0xff2d2d2d)),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                height: 2000,
                child:
                GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.798,
                  ),
                  itemBuilder: (context, index) =>
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 150,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.5,
                              child: imageWidget(index),
                            ),
                          ),

                          SizedBox(
                            height: 95,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 2.5,
                            child: TextField(
                              onChanged: (petName) {
                                print(petName);
                              },
                              controller: controllerChanger(index),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Please Type Pets Diagnosis and Date',
                                hintStyle: TextStyle(color: Colors.grey),
                                alignLabelWithHint: true,
                              ),
                              scrollPadding: const EdgeInsets.all(00.0),
                              keyboardType: TextInputType.multiline,
                              minLines: 2,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              autofocus: false,
                            ),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(int index) {
    if (index == 0) {
      return image1 != null
          ? Image.file(File("${image1?.path}"), fit: BoxFit.cover,)
          : elevatedWidget(index);
    } else if (index == 1) {
      return image2 != null
          ? Image.file(File("${image2?.path}"), fit: BoxFit.cover,)
          : elevatedWidget(index);
    } else if (index == 2) {
      return image3 != null
          ? Image.file(File("${image3?.path}"), fit: BoxFit.cover,)
          : elevatedWidget(index);
    } else if (index == 3) {
      return image4 != null
          ? Image.file(File("${image4?.path}"), fit: BoxFit.cover,)
          : elevatedWidget(index);
    } else if (index == 4) {
      return image5 != null
          ? Image.file(File("${image5?.path}"), fit: BoxFit.cover,)
          : elevatedWidget(index);
    } else {
      return image6 != null
          ? Image.file(File("${image6?.path}"), fit: BoxFit.cover,)
          : elevatedWidget(index);
    }
  }

  Widget elevatedWidget(int index) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xffFF8B6A)),
        onPressed: () async {
          var image = await imagePicker.pickImage(source: ImageSource.gallery);
          setState(() {
            if (index == 0) {
              image1 = image;
            } else if (index == 1) {
              image2 = image;
            } else if (index == 2) {
              image3 = image;
            } else if (index == 3) {
              image4 = image;
            } else if (index == 4) {
              image5 = image;
            } else {
              image6 = image;
            }
          });

        },
        child: Text("Select Image"));
  }
}

var controllers;

controllerChanger(index) {
  if (index == 0) {
    return controllers = controller1;
  }
  if (index == 1) {
    return controllers = controller2;
  }
  if (index == 2) {
    return controllers = controller3;
  }
  if (index == 3) {
    return controllers = controller4;
  }
  if (index == 4) {
    return controllers = controller5;
  }
  if (index == 5) {
    return controllers = controller6;
  }
}