import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigo/components/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatelessWidget {
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
                  'EMPLOYEE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/employee.svg",
                ),
                onLongPress: () {},
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
                  'SETTING',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/setting.svg",
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
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: textFieldBackgroundColor,
                            content: Text(
                                'Are you sure want to log out?',
                              style: TextStyle(
                                  fontSize: 16.0, color: textColor),
                            ),
                            actions: [
                              FlatButton(
                                child: Text(
                                    'CANCEL',
                                  style: TextStyle(
                                      fontSize: 14.0, color: textColor),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                    'LOG OUT',
                                  style: TextStyle(
                                      fontSize: 14.0, color: kSecondaryLightColor),
                                ),
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('role');
                                  Navigator.of(context)
                                      .pushReplacementNamed(loginScreen);
                                },
                              ),
                            ],
                          ));
                },
              ),
            ])));
  }
}
