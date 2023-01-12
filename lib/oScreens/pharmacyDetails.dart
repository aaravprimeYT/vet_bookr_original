import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/pharmacy.dart';
import 'package:http/http.dart' as http;
import 'package:vet_bookr/models/total_data_pharmacy.dart';

import '../utils/constants.dart';

class PharmacyDetails extends StatelessWidget {
  late Pharmacy pharmacy;

  PharmacyDetails(this.pharmacy);

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

  Future<TotalPharmacyData> getTotalData() async {
    List<double> latLng = await getLatLng();

    String searchUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet&location=${latLng[0]}%2C${latLng[1]}&radius=2500&type=pharmacy&key=${Constants.apiKey}";

    String pharmacyUrl = "https://www.google.com/maps/dir/?api=1"
        "&origin=${latLng[0]}&2C${latLng[1]}&destination=${pharmacy.placeId}&travelmode=driving&key=${Constants.apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(searchUrl));

    final Map<String, dynamic> data = jsonDecode(response.body);

    // print(data);

    List<Pharmacy> pharmacies = (data["results"] as List)
        .map((pharmacyJson) => Pharmacy.fromJson(pharmacyJson))
        .toList();

    /**
     * Adding the markerss
     */

    for (pharmacy in pharmacies) {
      final marker = Marker(
        markerId: MarkerId(pharmacy.placeId),
        position: LatLng(pharmacy.lat.toDouble(), pharmacy.lng.toDouble()),
        infoWindow: InfoWindow(
          title: pharmacy.name,
          snippet: pharmacy.address,
        ),
      );
      _markers.add(marker);
    }

    return TotalPharmacyData(
        usersLat: latLng[0], usersLng: latLng[1], pharmacy: pharmacies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("${pharmacy.name}"),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
            child: Text("${pharmacy.address}"),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
            child: Text("${pharmacy.timing}"),
          ),
          FutureBuilder<TotalPharmacyData>(
              future: getTotalData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return Container(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            snapshot.data!.usersLat, snapshot.data!.usersLng),
                        zoom: 11.0,
                      ),
                      markers: _markers,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }

                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }
}
