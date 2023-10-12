import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/vet_clinic.dart';

class PetPharmacyController {
  var apis = ['in 2.5 Kms', 'in 5 Kms', 'in 10 Kms', 'in 25 Kms', 'in 50 Kms'];

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
    await Geolocator.requestPermission();

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

  Future<List<VetClinic>> getPharmacyData(int distanceChanger) async {
    List<double> latLng = await getLatLng();
    List<VetClinic> petPharmacyData = [];

    String pharmacyApiUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet+pharmacies+near+me&location=${latLng[0]},${latLng[1]}&radius=$distanceChanger&type=veterinary_pharmacy&key=${Constants.apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(pharmacyApiUrl));

    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data);
    petPharmacyData = (data["results"] as List).map((vetJson) {
      print(vetJson);
      return VetClinic.fromJson(vetJson);
    }).toList();
    print(petPharmacyData);
    for (int i = 0; i < petPharmacyData.length; i++) {
      String placeId = petPharmacyData[i].placeId;
      String pharmacyDetailsUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=${placeId}&key=${Constants.apiKey}";

      final response = await http.get(Uri.parse(pharmacyDetailsUrl));

      final Map<String, dynamic> data = jsonDecode(response.body);
      String phoneNumber = data['result']['formatted_phone_number'];

      petPharmacyData[i].phone = phoneNumber;
    }
    return petPharmacyData;
  }

  Future<void> makeACall(String phone) async {
    final call = Uri.parse('tel:' + phone);
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }
}
