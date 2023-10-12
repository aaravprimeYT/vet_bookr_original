import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Pet_Parks/Pet_Park_Controller.dart';
import 'package:vet_bookr/oScreens/vetMaps.dart';

class PetParksPage extends StatefulWidget {
  // PetParksPage(this.vetClinic);
  const PetParksPage({super.key});

  @override
  State<PetParksPage> createState() => _PetParksPageState();
}

class _PetParksPageState extends State<PetParksPage> {
  PetParkController petParkController = PetParkController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    petParkController.getTotalData();
    setState(() {
      petParkController.isLoading = false;
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void apisChanger() async {
    setState(() {
      petParkController.isLoading = true;
    });
    if (petParkController.dropdownvalue == petParkController.apis[0]) {
      petParkController.apiChanger = 2500;
      await petParkController.getTotalData();
      print(petParkController.apiChanger);
    }
    if (petParkController.dropdownvalue == petParkController.apis[1]) {
      petParkController.apiChanger = 5000;
      await petParkController.getTotalData();
      print(petParkController.apiChanger);
    }
    if (petParkController.dropdownvalue == petParkController.apis[2]) {
      petParkController.apiChanger = 10000;
      await petParkController.getTotalData();
      print(petParkController.apiChanger);
    }
    if (petParkController.dropdownvalue == petParkController.apis[3]) {
      petParkController.apiChanger = 25000;
      await petParkController.getTotalData();
      print(petParkController.apiChanger);
    }
    if (petParkController.dropdownvalue == petParkController.apis[4]) {
      petParkController.apiChanger = 50000;
      await petParkController.getTotalData();
      print(petParkController.apiChanger);
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
                      'Best Pet Parks Near Me',
                      style: TextStyle(
                          color: Color(0xffFF8B6A), fontSize: 0.04.sw),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.017.sh, left: 0.01.sw),
                    height: 0.04.sh,
                    child: DropdownButton(
                      value: petParkController.dropdownvalue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: petParkController.apis.map((String items) {
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
                          petParkController.dropdownvalue = newValue!;
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
              petParkController.isLoading
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
                      itemCount: petParkController.vetClinic?.length,
                      itemBuilder: ((context, index) {
                        return clinicTile(petParkController.vetClinic![index]);
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
