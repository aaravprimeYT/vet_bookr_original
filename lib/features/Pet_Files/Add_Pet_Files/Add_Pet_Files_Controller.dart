import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  final administrationController = TextEditingController();
  final expiryController = TextEditingController();

  bool noImage = true;

  final storageRef = FirebaseStorage.instance.ref();

  File? pdfFile;

  String imageUrl = "";
  List<String> imageUrlList = [];
  int index = 0;


  Future<void> addPetToFireStore(Map<String, dynamic> addedPet,
      String petId) async {
    var doc = FirebaseFirestore.instance.collection("petFiles").doc();
    await FirebaseFirestore.instance
        .collection("petFiles")
        .doc(doc.id)
        .set(addedPet);
    print(doc.id);
    print(petId);
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(petId)
        .update({
      "petFiles": FieldValue.arrayUnion([doc.id])
    });
  }
}
