  class Social {
  final double lat;
  final double lng;
  final String name;
  final String placeId;
  final double rating;
  final String address;
  final double timing;

  const Social(
      {required this.name,
        required this.address,
        required this.rating,
        required this.placeId,
        required this.lat,
        required this.lng,
        required this.timing});

  factory Social.fromJson(Map<String, dynamic> socialJson) => Social(
      name: socialJson["name"],
      address: socialJson["vicinity"],
      rating: socialJson["rating"].toDouble(),
      placeId: socialJson["place_id"],
      lat: socialJson["geometry"]["location"]["lat"],
      lng: socialJson["geometry"]["location"]["lng"],
      timing: socialJson["opening_hours"]
  );
}
