import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/models/sizeConfig.dart';

import 'addPet_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  myPetTile() {
    return Container(
      margin: EdgeInsets.all(5),
      height: SizeConfig.blockSizeHorizontal! * 30,
      width: SizeConfig.blockSizeHorizontal! * 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.redAccent[100]),
    );
  }

  clinicTile({String? name, String? address}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: SizeConfig.blockSizeHorizontal! * 50,
          // height: SizeConfig.blockSizeVertical! * ,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[350],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name!,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              //sBox(h: 2),
              Text(address!, style: TextStyle(fontSize: 16))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // sBox(h: 30),
            Container(
              height: SizeConfig.screenHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: SizeConfig.screenWidth,
                    ),
                    const Text(
                      'Recent Clinincs',
                      style: TextStyle(fontSize: 22),
                    ),
                    // sBox(h: 2),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: ((context, index) {
                          return clinicTile(
                              name: 'Dr. Pet Clinic',
                              address: '2404 North Crocker Dr');
                        }),
                      ),
                    ),
                    //sBox(h: 4),
                    const Text(
                      'My Pets',
                      style: TextStyle(fontSize: 22),
                    ),
                    // sBox(h: 1),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: ((context, index) {
                          return myPetTile();
                        }),
                      ),
                    ),
                    //sBox(h: 1),
                    TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: Size(SizeConfig.screenWidth!,
                              SizeConfig.blockSizeVertical! * 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.grey[200]),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPetHome()));
                      },
                      child: const Text(
                        '+\nAdd Pet',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 28),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
