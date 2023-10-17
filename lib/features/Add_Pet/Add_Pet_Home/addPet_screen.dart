import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/features/Add_Pet/Add_Pet_Home/Add_Pet_Controller.dart';

class AddPetHome extends StatefulWidget {
  const AddPetHome({super.key});

  @override
  State<AddPetHome> createState() => _AddPetHomeState();
}

String petName = "";
int petAge = 0;
double petWeight = 0;
String petBreed = "";
String vaccinationDate = "";

final nameController = TextEditingController();
final ageController = TextEditingController();
final breedController = TextEditingController();
final weightController = TextEditingController();

class _AddPetHomeState extends State<AddPetHome> {
  AddPetController addPetController = AddPetController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
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
        extendBodyBehindAppBar: true,
        backgroundColor: kBackgroundColor,
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // sBox(h: 10),
                  Text(
                    'My Pet Details',
                    style: TextStyle(
                      color: Color(0xffF08519),
                      fontSize: 0.05.sw,
                    ),
                  ),
                  //      myPetTile()
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      addPetController.profilePic = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 75.sp,
                      backgroundColor: Color(0xffFF8B6A),
                      child: addPetController.profilePic == null
                          ? Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Text(
                                "Click here to add a profile picture for your pet",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                height: 0.7.sh,
                                width: 0.7.sh,
                                child: Image.file(
                                  fit: BoxFit.cover,
                                  File(
                                    "${addPetController.profilePic?.path}",
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                          top: 0.02.sh, left: 0.05.sw, right: 0.05.sw),
                      child: TextField(
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 0.017.sh),
                        controller: addPetController.controllerChanger(index),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.sp),
                          hintText: addPetController.hintTextChanger(index),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 0.017.sh),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.02.sh,
                        left: 0.05.sw,
                        right: 0.05.sw,
                        bottom: 0.02.sh),
                    child: TextField(
                        controller: addPetController.vaccinationController,
                        onTap: () => {
                              showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Color(0xffFF8B6A),
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                primary: Color(
                                                    0xffFF8B6A), // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 4),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                if (value == null) {
                                  return;
                                } else {
                                  addPetController.vaccinationController.text =
                                      "${value.day}/${value.month}/${value.year}";
                                }
                              })
                            },
                        readOnly: true,
                        style: TextStyle(fontSize: 0.017.sh),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                              borderSide: BorderSide(color: Color(0xffFF8B6A))),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.03.sw,
                          ),
                          hintText: "Last Vaccination Date ",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 0.017.sh),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (name) {
                          setState(() {
                            vaccinationDate = addPetController
                                .vaccinationController as String;
                          });
                        }),
                  ),
                  buttonWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 0.4.sw,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff5EBB86),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  onPressed: () async {
                    bool isEmpty = false;

                    for (var i = 0; i < 4; i++) {
                      if (addPetController.controllerChanger(i).text == "") {
                        isEmpty = true;
                        break;
                      }
                    }

                    setState(() {
                      addPetController.isLoading = true;
                    });
                    if (isEmpty ||
                        addPetController.vaccinationController.text == "" ||
                        addPetController.profilePic?.path == null) {
                      const snackBar = SnackBar(
                        content: Text("One of these fields is empty"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MenuScreen()));
                      // vaccinationDate =
                      //     "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";

                      Map<String, dynamic> addedPet = {
                        "name": addPetController.controllerChanger(0).text,
                        "age": addPetController.controllerChanger(1).text,
                        "weight": addPetController.controllerChanger(3).text,
                        "breed": addPetController.controllerChanger(2).text,
                        "profilePicture": addPetController.imageUrl,
                        "id": "",
                        "petFiles": [],
                        "lastVaccinationDate":
                            addPetController.vaccinationController.text
                      };
                      await addPetController.addPetToFireStore(
                          addedPet, context);
                      for (var i = 0; i < 4; i++) {
                        addPetController.controllerChanger(i).clear();
                      }
                      Navigator.pop(context);
                    }
                    setState(() {
                      addPetController.isLoading = false;
                    });
                  },
                  child: addPetController.isLoading
                      ? Container(
                          height: 15.sp,
                          width: 15.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 0.03.sw,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
            ),
          ],
        ),
      ],
    );
  }
}

// variableChanger(index, value) {
//   if (index == 0) {
//     return petName = value;
//   }
//   if (index == 1) {
//     return petAge = value;
//   }
//   if (index == 2) {
//     return petBreed = value;
//   }
//   if (index == 3) {
//     return petWeight = value;
//   }
// }
