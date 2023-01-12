import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/oScreens/home.dart';
import 'package:vet_bookr/oScreens/login_page.dart';
import 'package:vet_bookr/oScreens/petCafes_page.dart';
import 'package:vet_bookr/oScreens/petPharmacies_part.dart';
import 'package:vet_bookr/oScreens/welcome_screen.dart';

import '../models/pharmacy.dart';
import '../models/social.dart';
import 'petClinics_page.dart';

class HomePage extends StatefulWidget {
  // final User user;
  //  final FirebaseAuth auth;
  const HomePage({super.key});
  //  late final User user;
  // late final FirebaseAuth auth;

  // HomePage({required this.auth, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Future<bool?> onBackPressed(BuildContext context) {
  //   // show Dialog will return the boolean value

  //   return showDialog<bool>(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             content: const Text("Are you sure?"),
  //             title: const Text("Do you want to exit"),
  //             actions: [
  //               ElevatedButton(
  //                   onPressed: () => Navigator.pop(context, false),
  //                   child: const Text("No")),
  //               /**
  //        * When yes is pressed we have to sign out the user
  //        */
  //               ElevatedButton(
  //                   onPressed: () async {
  //                     await signOutUser();
  //                     return Navigator.pop(context, true);
  //                   },
  //                   child: const Text("Yes"))
  //             ],
  //           ));
  // }

  final iconsList = <IconData>[
    Icons.home,
    Icons.local_hospital,
    Icons.local_drink,
    Icons.local_pharmacy,
  ];

  var navigationIndex = [
    // HomePage(auth: auth, user: user),
    Home(),
    PetClinicsPage(),
    PetCafesPage(),
    PetPharmaciesPage(),
  ];

  static Social? get social => null;

  static Pharmacy? get pharmacy => null;

  static get user => null;

  static get auth => null;

  // Future<bool?> _onBackPressed(BuildContext context) {

  //   // show Dialog will return the boolean value

  //   return showDialog<bool>(context: context, builder: (context)=>AlertDialog(
  //     content: const Text("Are you sure?"),
  //     title: const Text("Do you want to exit"),

  //     actions: [
  //       ElevatedButton(onPressed: ()=>Navigator.pop(context,false), child: const Text("No")),
  //       /**
  //        * When yes is pressed we have to sign out the user
  //        */
  //       ElevatedButton(onPressed: () async{
  //         await signOutUser();
  //  return Navigator.pop(context,true);
  //   }, child
  //   : const Text("Yes"))
  //     ],
  //   ));
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          items: [
            SalomonBottomBarItem(icon: Icon(Icons.home), title: Text("Home")),
            SalomonBottomBarItem(
                icon: Icon(Icons.local_hospital), title: Text("Clinics")),
            SalomonBottomBarItem(
                icon: Icon(Icons.local_drink), title: Text("Pet Social")),
            SalomonBottomBarItem(
                icon: Icon(Icons.local_pharmacy), title: Text("Pharmacy")),
          ],
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
        body: navigationIndex[_selectedIndex]);
  }
  // signOutUser() async {
  //   await widget.auth.signOut().then((value) {
  //     //First show a snackbar that says the user is signed out
  //     const snackBar = SnackBar(content: Text("User has been signed out"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }

  //  signOutUser() async{

  //   await widget.auth.signOut().then((value) {
  //     //First show a snackbar that says the user is signed out
  //     const snackBar = SnackBar(
  //         content: Text("User has been signed out"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }
}
