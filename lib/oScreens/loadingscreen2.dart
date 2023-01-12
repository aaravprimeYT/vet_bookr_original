import 'dart:async';
import 'package:vet_bookr/constant.dart';
import 'package:flutter/material.dart';
import 'package:vet_bookr/oScreens/clinicsloading.dart';

class LoadingScreen2 extends StatefulWidget {
  const LoadingScreen2({Key? key}) : super(key: key);

  @override
  State<LoadingScreen2> createState() => _LoadingScreen2State();
}

class _LoadingScreen2State extends State<LoadingScreen2> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SplashScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Image.asset("assets/dog_gif.mp4")
    );
  }
}
