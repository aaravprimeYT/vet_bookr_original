/**
 * Pet Model Class
 */

class Pet {
  final String name;
  final int age;
  final double weight;
  final String breed;
  final String profilePicture;
  List<String> vaccinationDates = [];

  Pet({
    required this.name,
    required this.age,
    required this.weight,
    required this.breed,
    required this.profilePicture,
  });

  void addVaccination(String vaccinationDate) {
    vaccinationDates.add(vaccinationDate);
  }

  factory Pet.fromJson(Map<String, dynamic> petJson, {petName}) => Pet(
    name: petJson["petName"],
    age: petJson["petAge"],
    weight: petJson["petWeight"],
    breed: petJson["petBreed"],
    profilePicture: petJson["profilePicture"]
  );

  List<String> getVaccinationDate(Map<String, dynamic> petJson) =>
      petJson["vaccination"];
}
