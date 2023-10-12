import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/prescription.dart';

class PetFilesController {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;

  DateTime selectedDate = DateTime.now();
  final nameController = TextEditingController();

  List<Prescription> prescArray = [];

  bool isLoading = false;

  final vaccinationController = TextEditingController();

  bool noImage = true;

  final storageRef = FirebaseStorage.instance.ref();

  var petId = DateTime.now().millisecondsSinceEpoch.toString();

  File? pdfFile;

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  String imageUrl = "";
  List<String> imageUrlList = [];
  int index = 0;

  Future<void> uploadImages(
      {required String path,
      required String name,
      required BuildContext context}) async {
    try {
      final imageRef = storageRef.child(
          "Users/${FirebaseAuth.instance.currentUser?.uid}/$petId$index");
      index++;
      await imageRef.putFile(File(path));
      imageUrl = await imageRef.getDownloadURL();
      imageUrlList.add(imageUrl);
      print(imageRef.getDownloadURL());
    } on FirebaseException catch (e) {
      print("Function does work");
      SnackBar snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> addPetToFireStore(Map<String, dynamic> addedPet) async {
    var doc = FirebaseFirestore.instance.collection("petFiles").doc();
    await FirebaseFirestore.instance
        .collection("petFiles")
        .doc(doc.id)
        .set(addedPet);
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(petId)
        .update({
      "petFiles": FieldValue.arrayUnion([doc.id])
    });
  }
}
