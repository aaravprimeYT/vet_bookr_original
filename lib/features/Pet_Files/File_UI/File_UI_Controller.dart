import 'package:cloud_firestore/cloud_firestore.dart';

class FileUIController {
  late Map<String, dynamic> petDetails;

  late Map<String, dynamic> details;

  bool isLoading = true;

  void getFileDetails(String id) async {
    DocumentSnapshot<Map<String, dynamic>> petDetails = await FirebaseFirestore
        .instance
        .collection("petFiles")
        .doc(id)
        .get();
    details = petDetails.data()!;
    details.putIfAbsent("id", () => id);
    print(petDetails.data());
  }
}