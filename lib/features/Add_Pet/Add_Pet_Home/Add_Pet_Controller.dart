import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_bookr/models/prescription.dart';

import 'addPet_screen.dart';

class AddPetController {
  DateTime selectedDate = DateTime.now();

  List<Prescription> prescArray = [];

  bool isLoading = false;


  bool noImage = true;

  XFile? profilePic;
  ImagePicker imagePicker = ImagePicker();

  final storageRef = FirebaseStorage.instance.ref();

  String imageUrl = "";

  Future<void> uploadImages({required String path,
    required String id,
    required BuildContext context}) async {
    try {
      final imageRef = storageRef
          .child("Users/${FirebaseAuth.instance.currentUser?.uid}/$id");
      await imageRef.putFile(File(path));
      imageUrl = await imageRef.getDownloadURL();
      //print(imageRef.getDownloadURL());
    } on FirebaseException catch (e) {
      print("Function does work");
      SnackBar snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> addPetToFireStore(Map<String, dynamic> addedPet,
      BuildContext context) async {
    var doc = FirebaseFirestore.instance.collection("petDetails").doc();
    addedPet.update("id", (value) => doc.id);
    await uploadImages(path: profilePic!.path, id: doc.id, context: context);
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

  void myPrescription(List<Prescription> prescriptionArray) {
    prescArray = prescriptionArray;
    print(prescArray.length);
  }

  var controllers;

  controllerChanger(index) {
    if (index == 0) {
      return controllers = nameController;
    }
    if (index == 1) {
      return controllers = breedController;
    }
    if (index == 2) {
      return controllers = weightController;
    }
  }

  var hintText = "";

  hintTextChanger(index) {
    if (index == 0) {
      return hintText = "Name";
    }
    if (index == 1) {
      return hintText = "Breed";
    }
    if (index == 2) {
      return hintText = "Weight (Kg)";
    }
  }
}
