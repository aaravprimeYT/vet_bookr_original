import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Search_Location_Pharmacies/Search_Pharmacy_Controller.dart';
import 'package:vet_bookr/oScreens/vetMaps.dart';

class SearchLocationPharmacy extends StatefulWidget {
  // SearchLocationPharmacy(this.vetClinic);
  const SearchLocationPharmacy({super.key});

  @override
  State<SearchLocationPharmacy> createState() => _SearchLocationPharmacyState();
}

class _SearchLocationPharmacyState extends State<SearchLocationPharmacy> {
  SearchPharmacyController searchPharmacyController =
      SearchPharmacyController();

  @override
  void initState() {
    super.initState();
    searchPharmacyController.getTotalData();
  }

  void apisChanger() async {
    setState(() {
      searchPharmacyController.isLoading = true;
    });
    if (searchPharmacyController.dropdownvalue ==
        searchPharmacyController.apis[0]) {
      searchPharmacyController.apiChanger = 2500;
      searchPharmacyController.getTotalData();
      print(searchPharmacyController.apiChanger);
      clinicTile(searchPharmacyController.vetClinic);
    }
    if (searchPharmacyController.dropdownvalue ==
        searchPharmacyController.apis[1]) {
      searchPharmacyController.apiChanger = 5000;
      searchPharmacyController.getTotalData();
      print(searchPharmacyController.apiChanger);
      clinicTile(searchPharmacyController.vetClinic);
    }
    if (searchPharmacyController.dropdownvalue ==
        searchPharmacyController.apis[2]) {
      searchPharmacyController.apiChanger = 10000;
      searchPharmacyController.getTotalData();
      print(searchPharmacyController.apiChanger);
      clinicTile(searchPharmacyController.vetClinic);
    }
    if (searchPharmacyController.dropdownvalue ==
        searchPharmacyController.apis[3]) {
      searchPharmacyController.apiChanger = 25000;
      searchPharmacyController.getTotalData();
      print(searchPharmacyController.apiChanger);
      clinicTile(searchPharmacyController.vetClinic);
    }
    if (searchPharmacyController.dropdownvalue ==
        searchPharmacyController.apis[4]) {
      searchPharmacyController.apiChanger = 50000;
      searchPharmacyController.getTotalData();
      print(searchPharmacyController.apiChanger);
      clinicTile(searchPharmacyController.vetClinic);
    }
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
                        searchPharmacyController.selectedCountryCode =
                            country.countryCode;
                      });
                    },
                    onClosed: () async {
                      await searchPharmacyController.handlePressButton(context);
                      setState(() {
                        searchPharmacyController.isLoading = false;
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
                      'Pharmacies in Specific Location',
                      style: TextStyle(
                          color: Color(0xffFF8B6A), fontSize: 0.035.sw),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.02.sh, left: 0.01.sw),
                    height: 0.04.sh,
                    child: DropdownButton(
                      value: searchPharmacyController.dropdownvalue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: searchPharmacyController.apis.map((String items) {
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
                          searchPharmacyController.dropdownvalue = newValue!;
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
              searchPharmacyController.isLoading
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
                  : searchPharmacyController.vetClinic?.length == 0
                      ? Container(
                          height: 0.5.sh,
                          width: 1.sw,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Pharmacies Found!",
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
                          itemCount: searchPharmacyController.vetClinic?.length,
                          itemBuilder: ((context, index) {
                            return clinicTile(
                              searchPharmacyController.vetClinic![index],
                            );
                          }),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
