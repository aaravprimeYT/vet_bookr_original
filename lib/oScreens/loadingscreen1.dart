import 'dart:async';
import 'package:vet_bookr/constant.dart';
import 'package:flutter/material.dart';
import 'package:vet_bookr/oScreens/addPet_screen.dart';

class LoadingScreen1 extends StatefulWidget {
  const LoadingScreen1({Key? key}) : super(key: key);

  @override
  State<LoadingScreen1> createState() => _LoadingScreen1State();
}

class _LoadingScreen1State extends State<LoadingScreen1> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddPetHome())));
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
