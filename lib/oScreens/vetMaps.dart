import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/sizeConfig.dart';
import 'package:vet_bookr/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vet_bookr/models/total_data_vet.dart';
import 'package:vet_bookr/models/vet_clinic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class VetsMaps extends StatefulWidget {
  VetsMaps({Key? key, required this.vetClinic, this.latLong}) : super(key: key);
  VetClinic vetClinic;
  List<double>? latLong;
  @override
  State<VetsMaps> createState() => _VetsMapsState();
}

class _VetsMapsState extends State<VetsMaps> {
  late GoogleMapController googleMapController;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

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

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  Set<Marker> _markers = Set<Marker>();

  Future<List<double>> getLatLng() async {
    Position position = await determinePosition();
    List<double> latLong = [position.latitude, position.longitude];

    return latLong;
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late List<double> latLng;

  Future<TotalVetData> getTotalData() async {
    if (widget.latLong == null) {
      latLng = await getLatLng();
    } else {
      latLng = widget.latLong!;
    }
    print(latLng);
    _markers.add(Marker(
      //add start location marker
      markerId: MarkerId("Your Location"),
      position: LatLng(latLng[0], latLng[1]), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan), //Icon for Marker
    ));

    _markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(widget.vetClinic.placeId),
      position: LatLng(
          widget.vetClinic.lat.toDouble(), widget.vetClinic.lng.toDouble()),
      infoWindow: InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.apiKey,
      PointLatLng(latLng[0], latLng[1]),
      PointLatLng(widget.vetClinic.lat, widget.vetClinic.lng),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    addPolyLine(polylineCoordinates);
    //   String vetsUrl = "https://maps.googleapis.com/maps/api/directions/json?"
    //       "origin=${latLng[0]},${latLng[1]}&destination=${Uri.encodeComponent(widget.vetClinic.name)}&travelmode=driving&key=${Constants.apiKey}&destination_place_id=${widget.vetClinic.placeId}";
    //   print(vetsUrl);
    //   ///Getting the data
    //   final response = await http.get(Uri.parse(vetsUrl));
    //   final Map<String, dynamic> data = jsonDecode(response.body);
    // print(data);
    // List<VetClinic> vetClinics = (data["results"] as List)
    //     .map((vetJson) => VetClinic.fromJson(vetJson))
    //     .toList();
    /**
     * Adding the markerss
     */

    // for (var vetClinic in vetClinics) {
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

    return TotalVetData(
        usersLat: latLng[0], usersLng: latLng[1], vetClinics: []);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.08.sh),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 0.4.sw,
                    child: Column(
                      children: [
                        Text(
                          widget.vetClinic.name,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffFF8B6A)),
                        ),
                        Container(
                          width: 0.5.sw,
                          child: Divider(
                            thickness: 2,
                            color: Color(0xffFF8B6A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 0.2.sh,
                      width: 0.2.sh,
                      child: Image.asset("assets/detailsscreen.png")),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 25.sp, top: 10.sp, right: 25.sp),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Address: ${widget.vetClinic.address}"),
                      Row(
                        children: [
                          Text("Timing: "),
                          Text(
                            widget.vetClinic.timing
                                ? "Currently Open"
                                : "Currently Closed",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: widget.vetClinic.timing
                                    ? Colors.greenAccent
                                    : Colors.redAccent),
                          ),
                        ],
                      ),
                      RatingBar.builder(
                        initialRating: widget.vetClinic.rating,
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
                    ])),
            FutureBuilder<TotalVetData>(
                future: getTotalData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return Container(
                      margin: EdgeInsets.all(0.02.sh),
                      padding: EdgeInsets.all(0.015.sh),
                      height: 0.45.sh,
                      width: 0.52.sh,
                      color: Colors.white,
                      child: GoogleMap(
                        polylines: Set<Polyline>.of(polylines.values),
                        onMapCreated: _onMapCreated,
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer()))
                          ..add(Factory<ScaleGestureRecognizer>(
                              () => ScaleGestureRecognizer()))
                          ..add(Factory<TapGestureRecognizer>(
                              () => TapGestureRecognizer()))
                          ..add(Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer())),
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          //innital position in map
                          target: LatLng(latLng[0], latLng[1]),
                          //initial position
                          zoom: 16.0, //initial zoom level
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  return Container(
                    width: 1.sw,
                    height: 0.4.sh,
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
                  );
                }),
            SizedBox(height: 0.02.sh),
            Container(
              width: 0.3.sh,
              child: Image.asset("assets/logo.png"),
            )
          ],
        ),
      ),
    );
  }
}
