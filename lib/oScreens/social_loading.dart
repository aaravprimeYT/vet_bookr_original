import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/models/sizeConfig.dart';
import 'package:vet_bookr/oScreens/SocialFilter.dart';

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
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
          Padding(
            padding: EdgeInsets.only(top: 0.1.sh),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 75.sp, vertical: 10.sp),
              height: 0.65.sh,
              width: 1.sw,
              child: Image.asset(
                'assets/socialLoading.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(
            height: 0.05.sh,
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
