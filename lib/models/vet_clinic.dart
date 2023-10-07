class VetClinic {
  final double lat;
  final double lng;
  final String name;
  final String placeId;
  final double rating;
  final String address;
  final bool timing;
  final String phone;

  const VetClinic(
      {required this.name,
      required this.address,
      required this.rating,
      required this.placeId,
      required this.lat,
      required this.lng,
      required this.timing,
      required this.phone});

  factory VetClinic.fromJson(Map<String, dynamic> vetJson) => VetClinic(
        phone: "",
        name: vetJson["name"] ?? "",
        address: vetJson["vicinity"] ?? "",
        rating: vetJson["rating"].toDouble() ?? 0.0,
        placeId: vetJson["place_id"] ?? "",
        lat: vetJson["geometry"]["location"]["lat"],
        lng: vetJson["geometry"]["location"]["lng"],
        timing: vetJson["opening_hours"] == null
            ? false
            : vetJson["opening_hours"]["open_now"],
      );
}
