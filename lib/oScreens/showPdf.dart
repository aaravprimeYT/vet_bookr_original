import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({Key? key, required this.urls, required this.diseaseName})
      : super(key: key);

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
        child: ListView.builder(
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return Container(
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
            );
          },
        ),
      ),
    );
  }
}
