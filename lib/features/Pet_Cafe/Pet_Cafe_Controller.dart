import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/vet_clinic.dart';

class PetCafeController {
  bool isLoading = true;

  String dropdownvalue = 'in 2.5 Kms';

  var apiChanger = 2500;

  var apis = ['in 2.5 Kms', 'in 5 Kms', 'in 10 Kms', 'in 25 Kms', 'in 50 Kms'];

  late List<VetClinic>? vetClinic;

  late GoogleMapController googleMapController;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';

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
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet+cafe&location=${latLng[0]},${latLng[1]}&radius=$apiChanger&type=pet_cafe&key=${Constants
        .apiKey}";
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
    //if (!mounted) return;

  }
}
