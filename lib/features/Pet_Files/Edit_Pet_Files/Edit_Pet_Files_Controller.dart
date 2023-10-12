import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPetFilesController {
  final nameController = TextEditingController();

  @override
  void initState(Map<String, dynamic> details) {
    // TODO: implement initState
    nameController.text = details["name"];
    vaccinationController.text = details["date"];
  }

  bool isLoading = false;
  bool deleteLoading = false;

  final vaccinationController = TextEditingController();

  Future<void> addPetToFireStore(
      Map<String, dynamic> addedPet, details, petId) async {
    await FirebaseFirestore.instance
        .collection("petFiles")
        .doc(details["id"])
        .update(addedPet);

    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection("petsDetails")
        .doc(petId)
        .get();
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(petId)
        .update({
      "petFiles": FieldValue.arrayRemove(
        snap.data()!["petFiles"]!,
      ),
    });
    await FirebaseFirestore.instance
        .collection("petsDetails")
        .doc(petId)
        .update({
      "petFiles": FieldValue.arrayUnion(
        snap.data()!["petFiles"]!,
      ),
    });
  }
}
