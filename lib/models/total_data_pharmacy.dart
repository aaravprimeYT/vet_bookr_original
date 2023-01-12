import 'package:vet_bookr/models/pharmacy.dart';

class TotalPharmacyData{

  double usersLat;
  double usersLng;

  List<Pharmacy> pharmacy;

  TotalPharmacyData({
    required this.usersLat,
    required this.usersLng,
    required this.pharmacy
  });
}