import 'package:vet_bookr/models/pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:vet_bookr/oScreens/pharmacyDetails.dart';

class PharmacyList extends StatelessWidget {
  Pharmacy pharmacy;

  PharmacyList(this.pharmacy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vet List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                title: Text("${pharmacy.name}"),
                subtitle: Text("${pharmacy.timing}"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PharmacyDetails(pharmacy)));
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                title: Text("${pharmacy.name}"),
                subtitle: Text("${pharmacy.timing}"),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                title: Text("${pharmacy.name}"),
                subtitle: Text("${pharmacy.timing}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
