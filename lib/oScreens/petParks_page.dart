import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/vet_clinic.dart';
import 'package:vet_bookr/oScreens/vetMaps.dart';
import 'package:http/http.dart' as http;

import '../models/sizeConfig.dart';
import '../models/total_data_vet.dart';
import '../utils/constants.dart';

class PetParksPage extends StatefulWidget {
  // PetParksPage(this.vetClinic);
  const PetParksPage({super.key});

  @override
  State<PetParksPage> createState() => _PetParksPageState();
}

class _PetParksPageState extends State<PetParksPage> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet+parks&location=${latLng[0]},${latLng[1]}&radius=2500&type=pet-parks&key=${Constants.apiKey}";
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
    if(!mounted) return;

    setState(() {
      isLoading = false;
    });

    // for (vetClinic in vetClinics) {
    //   final marker = Marker(
    //     markerId: MarkerId(vetClinic.placeId),
    //     position: LatLng(vetClinic.lat.toDouble(), vetClinic.lng.toDouble()),
    //     infoWindow: InfoWindow(
    //       title: vetClinic.name,
    //       snippet: vetClinic.address,
    //     ),
    //   );
    //   _markers.add(marker);
    // }

    // return TotalVetData(
    //     usersLat: latLng[0], usersLng: latLng[1], vetClinics: vetClinics);
  }

  clinicTile(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VetsMaps(vetClinic: data,)));
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
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Color(0xffFF8B6A)),
                ),
                SizedBox(height: 0.008.sh,),
                Text(
                  data.address,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 0.005.sh,),
                Text(
                  data.timing?"Currently Open":"Currently Closed",
                  style: TextStyle(fontSize: 15.sp,color: data.timing?Colors.greenAccent:Colors.redAccent),
                ),
                SizedBox(height: 0.005.sh,),
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
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.sp,left: 10.sp,right: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  sBox(h: 10),
              Padding(
                padding: EdgeInsets.only(left: 10.0.sp,top: 15.sp),
                child: Text(
                  'Best Pet Parks Near Me',
                  style: TextStyle(color: Colors.deepOrange[300], fontSize: 22),
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.deepOrange[300],
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
                itemCount: vetClinic?.length,
                itemBuilder: ((context, index) {
                  return clinicTile(vetClinic![index]);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
