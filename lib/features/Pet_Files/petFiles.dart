import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/constant.dart';
import 'package:vet_bookr/oScreens/showImage.dart';

class PetFiles extends StatefulWidget {
  PetFiles({super.key, required this.petFileDetails});

  Map<String, dynamic> petFileDetails;

  @override
  State<PetFiles> createState() => _PetFilesState();
}

// final Stream<QuerySnapshot> _usersStream =
//     FirebaseFirestore.instance.collection('petsDetails').snapshots();

@override
class _PetFilesState extends State<PetFiles> {
  bool isLoading = false;

  //AddPetFiles addPetFiles = AddPetFiles(petId: );

  @override
  void initState() {
    fileChanger();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 0.175.sw),
          child: Text(
            "${widget.petFileDetails["name"]} Record",
            style: TextStyle(color: Color(0xffF08519), fontSize: 18.sp),
          ),
        ),
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
      backgroundColor: kBackgroundColor,
      body: Container(
        height: h,
        width: w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.01.sh, left: 0.09.sw),
                child: Text(
                  "Notes",
                  style: TextStyle(color: Color(0xffF08714), fontSize: 17.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0.005.sh, left: 0.09.sw, right: 0.09.sw),
                child: Text(
                  widget.petFileDetails["notes"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.005.sh, left: 0.07.sw),
                child: Container(
                  width: 0.86.sw,
                  height: 1,
                  color: Color(0xff75C3F4).withOpacity(0.3),
                ),
              ),
              SizedBox(
                height: 0.01.sh,
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.03.sh, top: 0.02.sh),
                    child: Text(
                      "Prescription",
                      style:
                          TextStyle(fontSize: 17.sp, color: Color(0xffF08714)),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.11.sw, right: 0.11.sw),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 20.sp),
                            shrinkWrap: true,
                            itemCount: widget.petFileDetails["files"].length,
                            itemBuilder: (context, index) {
                              return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.insert_drive_file,
                                        size: 130,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.sp),
                                        color: Colors.white,
                                      ),
                                      width: 0.34.sw,
                                      height: 200,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.sp),
                                          color: Color(0xffFEDDBB),
                                        ),
                                        alignment: Alignment.center,
                                        width: 0.34.sw,
                                        height: 50,
                                        child: Text("file name"),
                                      ),
                                    )
                                  ]);
                            }),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 0.11.sw, right: 0.11.sw, top: 0.015.sh),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20.sp),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.petFileDetails["images"].length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowImage(
                                          urls: widget.petFileDetails["images"],
                                          diseaseName:
                                              widget.petFileDetails["name"],
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          child: CachedNetworkImage(
                                            width: 0.34.sw,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                widget.petFileDetails["images"]
                                                    [index],
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Container(
                                              height: 5.sp,
                                              width: 5.sp,
                                              child: CircularProgressIndicator(
                                                color: Color(0xffFF8B6A),
                                                strokeWidth: 2.sp,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.sp),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.sp),
                                              color: Color(0xffFEDDBB),
                                            ),
                                            alignment: Alignment.center,
                                            width: 0.34.sw,
                                            height: 50,
                                            child: Text("image name"),
                                          ),
                                        )
                                      ]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // 3. On click of the file icon, you have to use a package which will display pdf in url directly in your app
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> fileText = [];

  void fileChanger() async {
    for (var index in widget.petFileDetails["files"]) {
      fileText = widget.petFileDetails["files"];
    }
    print(widget.petFileDetails["files"]);
  }
}
//
