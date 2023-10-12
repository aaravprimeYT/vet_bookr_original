import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/vet_clinic.dart';

class PetBoardingController {
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

  Future<List<VetClinic>> getPetBoardersData(int distanceChanger) async {
    List<double> latLng = await getLatLng();
    List<VetClinic> petBoardersData = [];

    String boardersApiUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet+boarding&location=${latLng[0]},${latLng[1]}&radius=$distanceChanger&type=pet_boarding&key=${Constants.apiKey}";
    final response = await http.get(Uri.parse(boardersApiUrl));

    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data);
    petBoardersData = (data["results"] as List).map((boardersDataJson) {
      print(boardersDataJson);
      return VetClinic.fromJson(boardersDataJson);
    }).toList();
    print(petBoardersData);

    for (int i = 0; i < petBoardersData.length; i++) {
      String placeId = petBoardersData[i].placeId;
      String boarderDetailsUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=${placeId}&key=${Constants.apiKey}";

      final response = await http.get(Uri.parse(boarderDetailsUrl));

      final Map<String, dynamic> data = jsonDecode(response.body);
      String phoneNumber = data['result']['formatted_phone_number'];

      petBoardersData[i].phone = phoneNumber;
    }

    return petBoardersData;
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
