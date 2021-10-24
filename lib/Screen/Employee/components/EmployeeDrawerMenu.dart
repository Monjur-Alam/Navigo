import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeDrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Colors.black,
            child: ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  'Roberto Aleydon',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ),
                accountEmail: Text(
                  'aleydon@gmail.com',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      ExactAssetImage('assets/images/profile_image.png'),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/header_bg.png"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: Text(
                  'CONTACTS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/contact.svg",
                ),
              ),
              ListTile(
                title: Text(
                  'HISTORY',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/history.svg",
                ),
                onLongPress: () {},
              ),
              ListTile(
                title: Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/logout.svg",
                ),
                onLongPress: () {},
              ),
            ])
        )
    );
  }
}
