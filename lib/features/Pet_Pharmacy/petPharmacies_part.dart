import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Pharmacy/Pet_Pharmacy_Controller.dart';
import 'package:vet_bookr/oScreens/vetMaps.dart';

import '../../models/vet_clinic.dart';

class PetPharmaciesPage extends StatefulWidget {
  // PetClinicsPage(this.vetClinic);
  const PetPharmaciesPage({super.key});

  @override
  State<PetPharmaciesPage> createState() => _PetPharmaciesPageState();
}

class _PetPharmaciesPageState extends State<PetPharmaciesPage> {
  bool isLoading = true;
  String dropdownValue = 'in 2.5 Kms';
  var distanceChanger = 2500;
  late List<VetClinic>? pharmacyList;
  PetPharmacyController petPharmacyController = PetPharmacyController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialisePharmacyData();
  }

  Future<void> initialisePharmacyData() async {
    pharmacyList = await petPharmacyController.getPharmacyData(distanceChanger);
    setState(() {
      isLoading = false;
    });
  }

  clinicTile(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VetsMaps(
                      vetClinic: data,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(top: 0.03.sh),
        width: 0.9.sw,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.sp),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFF8B6A)),
                ),
                SizedBox(
                  height: 0.008.sh,
                ),
                Text(
                  data.address,
                  style:
                      TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 0.005.sh,
                ),
                Text(
                  data.timing ? "Currently Open" : "Currently Closed",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color:
                          data.timing ? Colors.greenAccent : Colors.redAccent),
                ),
                SizedBox(
                  height: 0.005.sh,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: RatingBar.builder(
                        initialRating: data.rating,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemSize: 0.03.sh,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                        ignoreGestures: true,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.sp)),
                          backgroundColor: Color(0xffFF8B6A)),
                      onPressed: () async {
                        await petPharmacyController.makeACall(data.phone);
                      },
                      child: Text(
                        "Make a call",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 0.03.sw,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void apisChanger() async {
    setState(() {
      isLoading = true;
    });
    if (dropdownValue == petPharmacyController.apis[0]) {
      distanceChanger = 2500;
      await petPharmacyController.getPharmacyData(distanceChanger);
      print(distanceChanger);
    }
    if (dropdownValue == petPharmacyController.apis[1]) {
      distanceChanger = 5000;
      await petPharmacyController.getPharmacyData(distanceChanger);
      print(distanceChanger);
    }
    if (dropdownValue == petPharmacyController.apis[2]) {
      distanceChanger = 10000;
      await petPharmacyController.getPharmacyData(distanceChanger);
      print(distanceChanger);
    }
    if (dropdownValue == petPharmacyController.apis[3]) {
      distanceChanger = 25000;
      await petPharmacyController.getPharmacyData(distanceChanger);
      print(distanceChanger);
    }
    if (dropdownValue == petPharmacyController.apis[4]) {
      distanceChanger = 50000;
      await petPharmacyController.getPharmacyData(distanceChanger);
      print(distanceChanger);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.sp, left: 10.sp, right: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  sBox(h: 10),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.sp, top: 15.sp),
                    child: Text(
                      'Pet Pharmacies Near Me',
                      style: TextStyle(
                          color: Color(0xffFF8B6A), fontSize: 0.04.sw),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.017.sh, left: 0.01.sw),
                    height: 0.04.sh,
                    child: DropdownButton(
                      value: dropdownValue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: petPharmacyController.apis.map((String items) {
                        print(items);
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(fontSize: 0.04.sw),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                        apisChanger();
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                color: Color(0xffFF8B6A),
                indent: 15,
                endIndent: 10,
              ),
              // sBox(h: 1),
              isLoading
                  ? Container(
                      width: 1.sw,
                      height: 0.7.sh,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15.sp,
                            width: 15.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xffFF8B6A),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pharmacyList!.length,
                      itemBuilder: ((context, index) {
                        return clinicTile(pharmacyList![index]);
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
