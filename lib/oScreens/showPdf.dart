import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewerFromUrl extends StatelessWidget {
  PDFViewerFromUrl({Key? key, required this.url, required this.diseaseName}) : super(key: key);

  final String url;
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
        child: PDF().fromUrl(
          url,
          placeholder: (double progress) => Center(child: Text('$progress %')),
          errorWidget: (dynamic error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}