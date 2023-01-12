class Pharmacy {
  final double lat;
  final double lng;
  final String name;
  final String placeId;
  final double rating;
  final String address;
  final double timing;

  const Pharmacy(
      {required this.name,
        required this.address,
        required this.rating,
        required this.placeId,
        required this.lat,
        required this.lng,
        required this.timing});

  factory Pharmacy.fromJson(Map<String, dynamic> pharmacyJson) => Pharmacy(
      name: pharmacyJson["name"],
      address: pharmacyJson["vicinity"],
      rating: pharmacyJson["rating"].toDouble(),
      placeId: pharmacyJson["place_id"],
      lat: pharmacyJson["geometry"]["location"]["lat"],
      lng: pharmacyJson["geometry"]["location"]["lng"],
      timing: pharmacyJson["opening_hours"]
  );
}
