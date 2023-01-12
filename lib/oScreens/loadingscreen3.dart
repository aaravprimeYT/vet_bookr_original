import 'dart:async';
import 'package:vet_bookr/constant.dart';
import 'package:flutter/material.dart';
import 'package:vet_bookr/oScreens/pharma_Loading.dart';

class LoadingScreen3 extends StatefulWidget {
  const LoadingScreen3({Key? key}) : super(key: key);

  @override
  State<LoadingScreen3> createState() => _LoadingScreen3State();
}

class _LoadingScreen3State extends State<LoadingScreen3> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PharmaLoading())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Image.asset("assets/dog_gif.mp4", height: 100,width: 100)
    );
  }
}
