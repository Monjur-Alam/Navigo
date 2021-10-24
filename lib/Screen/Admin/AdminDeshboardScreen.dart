import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigo/Screen/Admin/Contact/ContactListScreen.dart';
import 'package:navigo/Screen/Admin/Employee/EmployeeListScreen.dart';
import 'package:navigo/Screen/Admin/History/HistoryScreen.dart';
import 'package:navigo/Screen/Admin/Task/Test.dart';
import 'package:navigo/components/Constant.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: buildBottomBar(),
    body: buildPages(),
  );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      selectedItemColor: kSecondaryLightColor,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/nav_home.svg"),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/employee.svg"),
          label: 'Employee',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/nav_contact.svg"),
          label: 'Contact',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/history.svg"),
          label: 'History',
          backgroundColor: Colors.black,
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return Test();
      case 1:
        return EmployeeListScreen();
      case 2:
        return ContactListScreen();
      case 3:
        return HistoryScreen();
      default:
        return Container();
    }
  }
}
