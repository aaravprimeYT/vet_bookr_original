import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowPdf extends StatelessWidget {
  ShowPdf(
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
    print(urls[index]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffFF8B6A),
        title: Text(diseaseName),
      ),
      body: Container(
        height: 1.sh,
        width: 1.sw,
        child: PDF(
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print(error.toString());
          },
        ).cachedFromUrl(
          urls[index],
          placeholder: (progress) => Text('$progress %'),
          errorWidget: (err) => Text(
            err.toString(),
          ),
        ),
      ),
    );
  }
}
