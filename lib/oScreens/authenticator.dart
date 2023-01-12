import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/oScreens/menu_screen.dart';
import 'package:vet_bookr/oScreens/welcome_screen.dart';

class Authenticator extends StatefulWidget {
  const Authenticator({Key? key}) : super(key: key);

  @override
  State<Authenticator> createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  @override
  void initState() {
    // TODO: implement initState
    validateUser();
    super.initState();
  }

  void validateUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool? loginCheck = preferences.getBool('isUserLoggedIn');

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || loginCheck == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      });
    } else {
      if (loginCheck == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen()));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WelcomePage()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: kCircularLoader,
      ),
    );
  }
}
