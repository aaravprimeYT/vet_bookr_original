import 'package:firebase_auth/firebase_auth.dart';

class BottomTabController {
  bool checkLogin() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
