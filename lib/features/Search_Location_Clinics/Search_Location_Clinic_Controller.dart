import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:vet_bookr/constant.dart';

import '../../models/vet_clinic.dart';

class SearchClinicController {
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
    isLoading = false;
  }

  Future<void> getTotalSearchData(var lat, var lng) async {
    isLoading = true;
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
    print("this is error");
    for (var i in vetClinic!) {
      String vetDetailsUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=${i.placeId}&key=${Constants.apiKey}";
      print(vetDetailsUrl);

      ///Getting the data
      final response = await http.get(Uri.parse(vetDetailsUrl));

      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data["formatted_phone_number"]);
    }

    /**
     * Adding the markerss
     */
    latLong = [lat, lng];
    isLoading = false;
  }

  void onError(PlacesAutocompleteResponse response) {
    print("adderror");
    print(response.errorMessage);
  }

  Future<void> handlePressButton(BuildContext context) async {
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

  String selectedCountryCode = "in";

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
      latLong![0] = lat!;
      latLong![1] = lng!;
      print("$lat,$lng");
      //print("${p.description} - $lat/$lng");
    }
  }

  List<double>? latLong;
}
