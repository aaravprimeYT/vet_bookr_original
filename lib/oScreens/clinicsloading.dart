import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/models/sizeConfig.dart';
import 'package:vet_bookr/oScreens/petClinics_page.dart';
import 'package:vet_bookr/oScreens/searchLocationLists/searchLocationClinics.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
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
            padding: EdgeInsets.symmetric(horizontal: 75.sp, vertical: 10.sp),
            height: 0.75.sh,
            width: 1.sw,
            child: Image.asset(
              'assets/clinicloadingscreen.png',
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFF8B6A))),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PetClinicsPage()));
            },
            child: Container(
              width: 0.55.sw,
              child: Text(
                "Find a Vet Near Me",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffD4F0FF))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchLocationClinics()));
            },
            child: Container(
              width: 0.55.sw,
              child: Text(
                "Enter Location Where You Find a Vet",
                style: TextStyle(
                  color: Color(0xff8B8B8C),
                  fontWeight: FontWeight.w400,
                  fontSize: 0.025.sw,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
