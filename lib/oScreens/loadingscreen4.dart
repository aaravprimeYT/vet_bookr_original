import 'dart:async';
import 'package:vet_bookr/constant.dart';
import 'package:flutter/material.dart';
import 'package:vet_bookr/oScreens/social_loading.dart';

class LoadingScreen4 extends StatefulWidget {
  const LoadingScreen4({Key? key}) : super(key: key);

  @override
  State<LoadingScreen4> createState() => _LoadingScreen4State();
}

class _LoadingScreen4State extends State<LoadingScreen4> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SocialLoading())));
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
