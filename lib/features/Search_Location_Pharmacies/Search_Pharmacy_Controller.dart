import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vet_bookr/constant.dart';

import '../../models/vet_clinic.dart';

class SearchPharmacyController {
  var apis = ['in 2.5 Kms', 'in 5 Kms', 'in 10 Kms', 'in 25 Kms', 'in 50 Kms'];

  late GoogleMapController googleMapController;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';

  Future<Position> determinePosition() async {
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

  Future<List<VetClinic>> getNearbyPharmacies(int distanceChanger) async {
    List<double> latLng = await getLatLng();
    List<VetClinic> pharmacyData = [];

    String pharmacyApiUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet+pharmacies+near+me&location=${latLng[0]},${latLng[1]}&radius=$distanceChanger&type=veterinary_pharmacy&key=${Constants.apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(pharmacyApiUrl));

    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data);
    pharmacyData = (data["results"] as List).map((vetJson) {
      print(vetJson);
      return VetClinic.fromJson(vetJson);
    }).toList();
    print(pharmacyData);

    for (int i = 0; i < pharmacyData.length; i++) {
      String placeId = pharmacyData[i].placeId;
      String pharmacyDetailUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=${placeId}&key=${Constants.apiKey}";

      final response = await http.get(Uri.parse(pharmacyDetailUrl));

      final Map<String, dynamic> data = jsonDecode(response.body);
      String phoneNumber = data['result']['formatted_phone_number'];

      pharmacyData[i].phone = phoneNumber;
    }
    return pharmacyData;
  }

  Future<List<VetClinic>> searchPharmacyData(double? lat, double? lng) async {
    latLong = [lat!, lng!];
    List<VetClinic> searchPharmacies = [];
    String searchPharmacyData =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=pet+pharmacies+near+me&location=$lat,$lng&radius=2500&type=veterinary_pharmacy&key=${Constants.apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(searchPharmacyData));

    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data);
    searchPharmacies = (data["results"] as List).map((vetJson) {
      print(vetJson);
      return VetClinic.fromJson(vetJson);
    }).toList();
    return searchPharmacies;
  }

  void onError(PlacesAutocompleteResponse response) {
    print("adderror");
    print(response.errorMessage);
  }

  Future<List<VetClinic>> getSearchPharmacyData(
      BuildContext context, String selectedCountryCode) async {
    Prediction? placePredictions = await PlacesAutocomplete.show(
        onError: onError,
        context: context,
        apiKey: Constants.apiKey,
        //onError: onError,
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        radius: 100000000000,
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
    List<VetClinic> searchPharmacies =
        await displayPrediction(placePredictions);
    return searchPharmacies;
  }

  Future<List<VetClinic>> displayPrediction(Prediction? placePrediction) async {
    if (placePrediction != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: "AIzaSyA1zlr6L_Ogiwf8uqwEOdKOpGcwra3xJUY",
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(placePrediction.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;
      List<VetClinic> searchPharmacies = await searchPharmacyData(lat, lng);
      latLong![0] = lat!;
      latLong![1] = lng!;
      return searchPharmacies;
    } else {
      return [];
    }
  }

  List<double>? latLong;

  Future<void> makeACall(String phone) async {
    final call = Uri.parse('tel:' + phone);
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }
}
