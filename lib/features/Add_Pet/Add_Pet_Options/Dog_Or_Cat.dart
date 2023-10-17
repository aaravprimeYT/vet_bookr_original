import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/features/Add_Pet/Add_Pet_Options/Cat_Gender.dart';

import '../../../constant.dart';
import 'Dog_Gender.dart';

class PetSelectionPage extends StatefulWidget {
  const PetSelectionPage({super.key});

  @override
  State<PetSelectionPage> createState() => _PetSelectionPageState();
}

class _PetSelectionPageState extends State<PetSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 0.15.sw),
          child: Text(
            'My Pet Details',
            style: TextStyle(
              color: Color(0xffF08519),
              fontSize: 0.05.sw,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 0.05.sw, top: 0.1.sh),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 0.5.sw),
              child: Text(
                "Do you have a ",
                style: TextStyle(
                  fontSize: 25.sp,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "dog ",
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: Color(0xff65C3FF),
                  ),
                ),
                Text(
                  "or a ",
                  style: TextStyle(
                    fontSize: 25.sp,
                  ),
                ),
                Text(
                  "cat",
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: Color(0xffFF8B6A),
                  ),
                ),
                Text(
                  "?",
                  style: TextStyle(
                    fontSize: 25.sp,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.05.sh, right: 0.05.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff65C3FF), elevation: 0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DogGenderSelection()));
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.015.sh),
                              child: Image.asset(
                                "assets/dog.png",
                                height: 0.1.sh,
                                width: 0.3.sw,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.015.sh, bottom: 0.01.sh),
                              child: Text(
                                "Dog",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF8B6A), elevation: 0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CatGenderSelection()));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.015.sh),
                          child: Image.asset(
                            "assets/cat.png",
                            height: 0.1.sh,
                            width: 0.3.sw,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 0.015.sh, bottom: 0.01.sh),
                          child: Text(
                            "Cat",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
