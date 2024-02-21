import 'package:flutter/material.dart';
import 'package:vet_bookr/features/Bottom_Tab_Navigator/bottom_tab_controller.dart';

import '../../constant.dart';
import '../Lost_&_Found/Lost_&_Found_Page.dart';
import '../Menu/menu_screen.dart';
import '../Pet_GPT/Pet_GPT_Page.dart';
import '../Pet_List/list_pet.dart';
import '../Settings/Settings_Page.dart';
import '../Welcome_Page/welcome_screen.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key});

  @override
  State<BottomTabPage> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage> {
  int bottomTabIndex = 2;
  BottomTabController bottomTabController = BottomTabController();

  void LoginChecker() {
    bool loginCheck = bottomTabController.checkLogin();
    if (loginCheck) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListPets(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
      );
    }
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return SettingsPage();
      case 1:
        return PetGPT();
      case 2:
        return ListPets();
      case 3:
        return LostNFound();
      case 4:
        return MenuScreen();

      default:
        return new Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomTabIndex,
        backgroundColor: kBackgroundColor,
        selectedItemColor: Colors.black,
        onTap: (value) {
          setState(() {
            bottomTabIndex = value;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(
              Icons.settings,
              color: Color(0xff65C3FF),
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.computer,
              color: Color(0xff65C3FF),
            ),
            label: 'Pet-GPT',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xff65C3FF),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_search,
              color: Color(0xff65C3FF),
            ),
            label: 'Lost & Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Color(0xff65C3FF),
            ),
            label: 'Find',
          ),
        ],
      ),
      body: _getDrawerItemWidget(bottomTabIndex),
    );
  }
}
