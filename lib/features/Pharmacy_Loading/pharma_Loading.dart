import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/features/Pet_Pharmacy/petPharmacies_part.dart';
import 'package:vet_bookr/features/Search_Location_Pharmacies/SearchLocationPharmacy.dart';
import 'package:vet_bookr/models/sizeConfig.dart';

class PharmaLoading extends StatefulWidget {
  const PharmaLoading({super.key});

  @override
  State<PharmaLoading> createState() => _PharmaLoadingState();
}

class _PharmaLoadingState extends State<PharmaLoading> {
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
      body: Container(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.1.sh),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 75.sp, vertical: 10.sp),
                height: 0.65.sh,
                width: 1.sw,
                child: Image.asset(
                  'assets/pharmacyloadingscreen.png',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PetPharmaciesPage()));
                },
                child: Container(
                  width: 0.65.sw,
                  child: Text(
                    "Find a Pet Pharmacy Near Me",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xffD4F0FF))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchLocationPharmacy()));
              },
              child: Container(
                width: 0.65.sw,
                child: Text(
                  "Enter Location Where You Need a Pet Pharmacy",
                  style: TextStyle(
                      color: Color(0xff8B8B8C),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.9.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
