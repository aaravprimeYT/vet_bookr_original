import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Search_Location_Clinics/Search_Location_Clinic_Controller.dart';
import 'package:vet_bookr/oScreens/vetMaps.dart';

class SearchLocationClinics extends StatefulWidget {
  // SearchLocationClinics(this.vetClinic);
  const SearchLocationClinics({super.key});

  @override
  State<SearchLocationClinics> createState() => _SearchLocationClinicsState();
}

class _SearchLocationClinicsState extends State<SearchLocationClinics> {
  SearchClinicController searchClinicController = SearchClinicController();

  @override
  void initState() {
    super.initState();
    searchClinicController.getTotalData();
  }

  void apisChanger() async {
    setState(() {
      searchClinicController.isLoading = true;
    });
    if (searchClinicController.dropdownvalue ==
        searchClinicController.apis[0]) {
      searchClinicController.apiChanger = 2500;
      searchClinicController.getTotalData();
      print(searchClinicController.apiChanger);
      clinicTile(searchClinicController.vetClinic);
    }
    if (searchClinicController.dropdownvalue ==
        searchClinicController.apis[1]) {
      searchClinicController.apiChanger = 5000;
      searchClinicController.getTotalData();
      print(searchClinicController.apiChanger);
      clinicTile(searchClinicController.vetClinic);
    }
    if (searchClinicController.dropdownvalue ==
        searchClinicController.apis[2]) {
      searchClinicController.apiChanger = 10000;
      searchClinicController.getTotalData();
      print(searchClinicController.apiChanger);
      clinicTile(searchClinicController.vetClinic);
    }
    if (searchClinicController.dropdownvalue ==
        searchClinicController.apis[3]) {
      searchClinicController.apiChanger = 25000;
      searchClinicController.getTotalData();
      print(searchClinicController.apiChanger);
      clinicTile(searchClinicController.vetClinic);
    }
    if (searchClinicController.dropdownvalue ==
        searchClinicController.apis[4]) {
      searchClinicController.apiChanger = 50000;
      searchClinicController.getTotalData();
      print(searchClinicController.apiChanger);
      clinicTile(searchClinicController.vetClinic);
    }
  }

  clinicTile(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VetsMaps(
                    vetClinic: data, latLong: searchClinicController.latLong)));
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.sp),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () async {
                showCountryPicker(
                    showPhoneCode: false,
                    context: context,
                    onSelect: (Country country) {
                      setState(() {
                        searchClinicController.selectedCountryCode =
                            country.countryCode;
                      });
                    },
                    onClosed: () async {
                      await searchClinicController.handlePressButton(context);
                      setState(() {
                        searchClinicController.isLoading = false;
                      });
                    });
              },
            ),
          ),
        ],
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
                    padding: EdgeInsets.only(left: 10.sp, top: 15.sp),
                    child: Text(
                      'Vet Clinics in Specific Location',
                      style: TextStyle(
                          color: Color(0xffFF8B6A), fontSize: 0.035.sw),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.02.sh, left: 0.01.sw),
                    height: 0.04.sh,
                    child: DropdownButton(
                      value: searchClinicController.dropdownvalue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: searchClinicController.apis.map((String items) {
                        print(items);
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(fontSize: 0.035.sw),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          searchClinicController.dropdownvalue = newValue!;
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
              searchClinicController.isLoading
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
                  : searchClinicController.vetClinic?.length == 0
                      ? Container(
                          height: 0.5.sh,
                          width: 1.sw,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Clinics Found!",
                                style: TextStyle(
                                  fontSize: 0.024.sh,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: searchClinicController.vetClinic?.length,
                          itemBuilder: ((context, index) {
                            return clinicTile(
                                searchClinicController.vetClinic![index]);
                          }),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
