import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/models/vet_clinic.dart';
import 'package:vet_bookr/oScreens/immunization_table.dart';
import 'package:vet_bookr/oScreens/prescription_upload.dart';

import 'package:vet_bookr/oScreens/vetMaps.dart';

import 'oScreens/addPet_screen.dart';
import 'oScreens/authenticator.dart';
import 'oScreens/immunization_table0.dart';
import 'oScreens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 300));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, widget) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Authenticator(),
        ),
      ),
    );
  }
}
