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

class SearchClinicController {
  final List<String> searchDistanceList = [
    'in 2.5 Kms',
    'in 5 Kms',
    'in 10 Kms',
    'in 25 Kms',
    'in 50 Kms'
  ];

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

  Future<List<VetClinic>> getNearbyVets(int distanceChanger) async {
    List<double> latLng = await getLatLng();
    List<VetClinic> vetClinicData = [];

    String searchVetApiURL =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=vets&location=${latLng[0]},${latLng[1]}&radius=$distanceChanger&type=veterinary_care&key=${Constants
        .apiKey}";

    // Getting the data
    final response = await http.get(Uri.parse(searchVetApiURL));
    final Map<String, dynamic> vetsData = jsonDecode(response.body);

    vetClinicData = (vetsData["results"] as List).map((vetJson) {
      return VetClinic.fromJson(vetJson);
    }).toList();
    print(vetClinicData);

    // Getting phone numbers
    for (int i = 0; i < vetClinicData.length; i++) {
      String placeId = vetClinicData[i].placeId;
      String vetDetailsUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=${placeId}&key=${Constants
          .apiKey}";

      final response = await http.get(Uri.parse(vetDetailsUrl));

      final Map<String, dynamic> data = jsonDecode(response.body);
      String phoneNumber = data['result']['formatted_phone_number'];

      vetClinicData[i].phone = phoneNumber;
    }

    return vetClinicData;
  }

  Future<List<VetClinic>> searchVetsData(double? lat, double? lng) async {
    latLong = [lat!, lng!];
    List<VetClinic> searchVetClinics = [];
    String searchVetsApiURL =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=vets&location=$lat,$lng&radius=2500&type=veterinary_care&key=${Constants
        .apiKey}";

    ///Getting the data
    final response = await http.get(Uri.parse(searchVetsApiURL));

    final Map<String, dynamic> searchVetsData = jsonDecode(response.body);
    searchVetClinics = (searchVetsData["results"] as List).map((vetJson) {
      return VetClinic.fromJson(vetJson);
    }).toList();

    return searchVetClinics;
  }

  void onError(PlacesAutocompleteResponse response) {
    print("adderror");
    print(response.errorMessage);
  }

  Future<List<VetClinic>> getSearchVetClinicsData(BuildContext context,
      String selectedCountryCode) async {
    Prediction? placePredictions = await PlacesAutocomplete.show(
        onError: onError,
        context: context,
        apiKey: Constants.apiKey,
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        language: "en",
        decoration: InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        components: [Component(Component.country, selectedCountryCode)]);
    List<VetClinic> searchVetClinics =
    await displayPrediction(placePredictions);
    return searchVetClinics;
  }

  Future<List<VetClinic>> displayPrediction(
      Prediction? placePredictions) async {
    if (placePredictions != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: Constants.apiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(placePredictions.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;
      List<VetClinic> searchVetsClinics = await searchVetsData(lat, lng);
      latLong![0] = lat!;
      latLong![1] = lng!;
      return searchVetsClinics;
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
