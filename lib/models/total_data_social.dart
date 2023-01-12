import 'package:vet_bookr/models/social.dart';

class TotalSocialData{

  double usersLat;
  double usersLng;

  List<Social> social;

  TotalSocialData({
    required this.usersLat,
    required this.usersLng,
    required this.social
  });
}