import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/vet_clinic.dart';
import 'package:vet_bookr/oScreens/vetMaps.dart';

class SearchLocationClinics extends StatefulWidget {
  // SearchLocationClinics(this.vetClinic);
  const SearchLocationClinics({super.key});

  @override
  State<SearchLocationClinics> createState() => _SearchLocationClinicsState();
}

class _SearchLocationClinicsState extends State<SearchLocationClinics> {
  bool isLoading = true;

  String dropdownvalue = 'in 2.5Kms';

  var apiChanger = 2500;

  var apis = [
    'in 2.5Kms',
    'in 5Kms',
    'in 10Kms',
  ];

  @override
  void initState() {
    super.initState();
    getTotalData();
  }

  late List<VetClinic>? vetClinic;

  late GoogleMapController googleMapController;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  Set<Marker> _markers = Set<Marker>();

  Future<Position> determinePosition() async {
    ///Check if location is enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return Future.error(_kLocationServicesDisabledMessage);
    }

    /**
     * Request Location Permission
     */
    await Geolocator.requestPermission();

    ///Check if the kind of permission we got

    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      return Future.error(_kPermissionDeniedMessage);
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(_kPermissionDeniedForeverMessage);
    }

    return Geolocator.getCurrentPosition();
  }

  Future<List<double>> getLatLng() async {
    Position position = await determinePosition();
    List<double> latLong = [position.latitude, position.longitude];

    return latLong;
  }

  Future<void> getTotalData() async {
    List<double> latLng = await getLatLng();

    String vetsUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=vets&location=${latLng[0]},${latLng[1]}&radius=$apiChanger&type=veterinary_care&key=${Constants.apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(vetsUrl));

    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data);
    vetClinic = (data["results"] as List).map((vetJson) {
      print(vetJson);
      return VetClinic.fromJson(vetJson);
    }).toList();
    print(vetClinic);
    /**
     * Adding the markerss
     */

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getTotalSearchData(var lat, var lng) async {
    setState(() {
      isLoading = true;
    });
    String vetsUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=vets&location=$lat,$lng&radius=2500&type=veterinary_care&key=${Constants.apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(vetsUrl));

    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data);
    vetClinic = (data["results"] as List).map((vetJson) {
      print(vetJson);
      return VetClinic.fromJson(vetJson);
    }).toList();
    print(vetClinic);
    /**
     * Adding the markerss
     */

    setState(() {
      latLong = [lat, lng];
      isLoading = false;
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    print("adderror");
    print(response.errorMessage);
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
        onError: onError,
        context: context,
        apiKey: "AIzaSyA1zlr6L_Ogiwf8uqwEOdKOpGcwra3xJUY",
        //onError: onError,
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        // radius: 100000000000,
        language: "en",
        decoration: InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        components: [Component(Component.country, selectedCountryCode)]);
    print("Prediction");
    print(p);
    await displayPrediction(p);
  }

  Future<void> displayPrediction(Prediction? p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyA1zlr6L_Ogiwf8uqwEOdKOpGcwra3xJUY",
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;
      await getTotalSearchData(lat, lng);
      setState(() {
        latLong![0] = lat!;
        latLong![1] = lng!;
      });
      print("$lat,$lng");
      //print("${p.description} - $lat/$lng");
    }
  }

  List<double>? latLong;

  clinicTile(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VetsMaps(vetClinic: data, latLong: latLong)));
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
      isLoading = true;
    });
    if (dropdownvalue == apis[0]) {
      apiChanger = 2500;
      getTotalData();
      print(apiChanger);
      clinicTile(vetClinic);
    }
    if (dropdownvalue == apis[1]) {
      apiChanger = 5000;
      getTotalData();
      print(apiChanger);
      clinicTile(vetClinic);
    }
    if (dropdownvalue == apis[2]) {
      apiChanger = 10000;
      getTotalData();
      print(apiChanger);
      clinicTile(vetClinic);
    }
  }

  String selectedCountryCode = "in";

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
                        selectedCountryCode = country.countryCode;
                      });
                    },
                    onClosed: () async {
                      await _handlePressButton();
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
                      value: dropdownvalue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: apis.map((String items) {
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
                        apisChanger();
                        setState(() {
                          dropdownvalue = newValue!;
                        });
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
                  : vetClinic?.length == 0
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
                          itemCount: vetClinic?.length,
                          itemBuilder: ((context, index) {
                            return clinicTile(vetClinic![index]);
                          }),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
