import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowImage extends StatelessWidget {
  ShowImage(
      {Key? key,
      required this.urls,
      required this.diseaseName,
      required this.index})
      : super(key: key);
  int index;
  List<dynamic> urls = [];
  String diseaseName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffFF8B6A),
        title: Text(diseaseName),
      ),
      body: Container(
        child: Container(
          width: 1.sw,
          margin: EdgeInsets.only(
            left: 0.05.sw,
            right: 0.05.sw,
            top: 0.02.sh,
          ),
          child: Image.network(
            "${urls[index]}",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
