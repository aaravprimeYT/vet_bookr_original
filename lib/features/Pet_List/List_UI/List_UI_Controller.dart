import 'package:cloud_firestore/cloud_firestore.dart';

class ListUIController {
  late Map<String, dynamic> details;

  bool isLoading = true;

  void getPetDetails(String id) async {
    DocumentSnapshot<Map<String, dynamic>> petDetails = await FirebaseFirestore
        .instance
        .collection("petsDetails")
        .doc(id)
        .get();
    //print(widget.id);
    details = petDetails.data()!;

    print(petDetails.data());
  }
}
