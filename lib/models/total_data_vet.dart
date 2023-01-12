import 'package:vet_bookr/models/vet_clinic.dart';

class TotalVetData{

  double usersLat;
  double usersLng;

  List<VetClinic> vetClinics;

  TotalVetData({
    required this.usersLat,
    required this.usersLng,
    required this.vetClinics
  });
}