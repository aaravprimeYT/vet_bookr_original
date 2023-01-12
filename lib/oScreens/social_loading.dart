import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/models/sizeConfig.dart';
import 'package:vet_bookr/oScreens/SocialFilter.dart';
import 'package:vet_bookr/oScreens/petClinics_page.dart';

class SocialLoading extends StatefulWidget {
  const SocialLoading({super.key});

  @override
  State<SocialLoading> createState() => _SocialLoadingState();
}

class _SocialLoadingState extends State<SocialLoading> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffFFD9B3),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.09.sh, bottom: 0.05.sh),
            height: 0.65.sh,
            width: 1.sw,
            child: Image.asset(
              'assets/socialLoading.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xffFF8B6A))),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PetSocialFilter()));
              },
              child: Text("Find More Fun for Your Pet",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ],
      )),
    );
  }
}
