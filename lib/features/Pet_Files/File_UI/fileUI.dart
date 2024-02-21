// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vet_bookr/features/Pet_Files/File_UI/File_UI_Controller.dart';
// import 'package:vet_bookr/oScreens/showImage.dart';
//
// import '../Edit_Pet_Files/editPetFiles.dart';
//
// class FileUI extends StatefulWidget {
//   FileUI({Key? key, required this.id, required this.petId}) : super(key: key);
//
//   String id;
//
//   String petId;
//
//   @override
//   State<FileUI> createState() => _FileUIState();
// }
//
// class _FileUIState extends State<FileUI> {
//   FileUIController fileUIController = FileUIController();
//
//   @override
//   void initState() {
//     fileUIController.getFileDetails(widget.id);
//     setState(() {
//       fileUIController.isLoading = false;
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return fileUIController.isLoading
//         ? Padding(
//             padding: EdgeInsets.all(0.095.sh),
//             child: CircularProgressIndicator(
//               color: Color(0xffFF8B6A),
//             ),
//           )
//         : GestureDetector(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Card(
//                   child: Container(
//                     width: 0.42.sw,
//                     padding: EdgeInsets.only(left: 0.03.sw),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 0.015.sh),
//                               child: Text(
//                                 "Record Type:",
//                                 style: TextStyle(
//                                     fontSize: 0.014.sh, color: Colors.black),
//                               ),
//                             ),
//                             Container(
//                               width: 0.07.sw,
//                               height: 0.07.sw,
//                               child: PopupMenuButton(
//                                 icon: Icon(
//                                   Icons.more_vert,
//                                   color: Colors.black,
//                                 ),
//                                 itemBuilder: (context) {
//                                   return [
//                                     PopupMenuItem<int>(
//                                       value: 0,
//                                       child: Text("Edit Record"),
//                                     ),
//                                   ];
//                                 },
//                                 onSelected: (value) async {
//                                   if (value == 0) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => EditPetFiles(
//                                           petId: widget.petId,
//                                           details: fileUIController.details,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                         Container(
//                           width: 0.42.sw,
//                           padding: EdgeInsets.only(top: 0.005.sh),
//                           child: Text(
//                             "${fileUIController.details["name"]}",
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontSize: 0.020.sh, color: Color(0xffF08714)),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 0.015.sh),
//                           child: Text(
//                             "Date:",
//                             style: TextStyle(
//                                 fontSize: 0.014.sh, color: Colors.black),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 0.005.sh),
//                           child: Text(
//                             "${fileUIController.details["date"]}",
//                             style: TextStyle(
//                                 fontSize: 0.020.sh, color: Color(0xffF08714)),
//                           ),
//                         ),
//                         Expanded(child: Container()),
//                         Container(
//                           width: 0.42.sw,
//                           margin: EdgeInsets.only(
//                             right: 0.03.sw,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               TextButton(
//                                 style: TextButton.styleFrom(
//                                     //fixedSize: Size(SizeConfig.blockSizeHorizontal! * 30,
//                                     //  SizeConfig.blockSizeVertical! * 6),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.sp)),
//                                     backgroundColor: Color(0xffFF8B6A)),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ImageViewer(
//                                         urls: fileUIController.details["files"],
//                                         diseaseName:
//                                             fileUIController.details["name"],
//                                         index: index,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   "View File",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 0.015.sh),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }
