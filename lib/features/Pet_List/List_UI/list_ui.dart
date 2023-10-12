import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vet_bookr/features/Pet_List/List_UI/List_UI_Controller.dart';
import 'package:vet_bookr/oScreens/showPetScreen.dart';

class ListUI extends StatefulWidget {
  ListUI({Key? key, required this.id}) : super(key: key);

  String id;

  @override
  State<ListUI> createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {

  ListUIController listUIController = ListUIController();

  @override
  void initState() {
    listUIController.getPetDetails(widget.id);
    setState(() {
      listUIController.isLoading = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return listUIController.isLoading
        ? Container(
      padding: EdgeInsets.all(75.sp),
      child: CircularProgressIndicator(
        color: Color(0xffFF8B6A),
      ),
    )
        : GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShowPet(details: listUIController.details)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: CircleAvatar(
                  backgroundImage:
                  NetworkImage(listUIController.details["profilePicture"]),
                  radius: 44.sp,
                  backgroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.01.sh),
                child: Text(
                  "${listUIController.details["name"]}",
                  style: TextStyle(
                      fontSize: 0.05.sw, color: Color(0xffF08714)),
                ),
              ),
              Flexible(
                flex: 0,
                child: Container(
                  width: 0.45.sw,
                  padding: EdgeInsets.only(
                    top: 0.01.sh,
                  ),
                  child: Text(
                    "${listUIController.details["breed"]}",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 0.04.sw),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
