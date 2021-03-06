import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigo/Screen/Employee/Contact/EmployeeContactListScreen.dart';
import 'package:navigo/Screen/Employee/History/EmployeeHistoryScreen.dart';
import 'package:navigo/Screen/Employee/Task/EmployeeTaskListScreen.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/helper/keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  @override
  EmployeeDashboardScreenState createState() =>
      new EmployeeDashboardScreenState();
}

class EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  String _appBarTitle = "Task List";
  String _userName = "Username";
  String _email = "abc@gmail.com";
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Task List");
  int _selectedIndex = 0;
  bool _isTitle = false;
  String _name = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchQuery = null;
      cusIcon = const Icon(Icons.search);
      _name = '';
      _selectedIndex = index;
      if (index == 0) {
        _isTitle = false;
        _appBarTitle = "Task List";
      } else if (index == 1) {
        _isTitle = false;
        _appBarTitle = "Contact List";
      } else if (index == 2) {
        _isTitle = false;
        _appBarTitle = "History";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isTitle = true;
                if (cusIcon.icon == Icons.search) {
                  cusIcon = const Icon(Icons.cancel);
                  cusSearchBar = TextField(
                    autofocus: true,
                    controller: _searchQuery,
                    onChanged: (value) {
                      _name = value;
                      setState(() {
                        buildPages();
                      });
                    },
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(color: textColor)),
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  );
                } else {
                  KeyboardUtil.hideKeyboard(context);
                  _name = '';
                  setState(() {
                    buildPages();
                  });
                  _searchQuery = null;
                  cusIcon = const Icon(Icons.search);
                  cusSearchBar = Text(_appBarTitle);
                }
              });
            },
            icon: cusIcon,
          ),
        ],
        title: _isTitle ? cusSearchBar : Text(_appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: bgColor,
      body: Center(
        child: buildPages(),
      ),
      drawer: _drawerMenu(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/nav_home.svg"),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/contact.svg"),
            label: 'Contact',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/history.svg"),
            label: 'History',
            backgroundColor: Colors.black,
          ),
        ],
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: kSecondaryLightColor,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.shifting,
        onTap: _onItemTapped,
      ),
    );
  }

  _getUserInfo() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection('employee')
        .doc(user.uid)
        .snapshots()
        .listen((employeeData) {
      setState(() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _userName = employeeData.data()['name'];
        _email = employeeData.data()['email'];
        prefs?.setString("username", _userName);
        prefs?.setString("email", _email);
      });
    });
  }

  Widget _drawerMenu() {
    return Drawer(
        child: Container(
            color: Colors.black,
            child: ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _userName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: kSecondaryLightColor,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                accountName: Text(
                  _userName,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ),
                accountEmail: Text(
                  _email,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
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
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedIndex = 1;
                    _isTitle = false;
                    _appBarTitle = "Contact List";
                  });
                },
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
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedIndex = 2;
                    _isTitle = false;
                    _appBarTitle = "History";
                  });
                },
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
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: textFieldBackgroundColor,
                        title: Text(
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
                                  fontSize: 14.0,
                                  color: kSecondaryLightColor),
                            ),
                            onPressed: () async {
                              final prefs =
                              await SharedPreferences.getInstance();
                              prefs.remove('role');
                              Navigator.of(context).pop();
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

  Widget buildPages() {
    switch (_selectedIndex) {
      case 0:
        return EmployeeTaskListScreen(name: _name);
      case 1:
        return EmployeeContactListScreen(name: _name);
      case 2:
        return EmployeeHistoryScreen(name: _name);
      default:
        return Container();
    }
  }
}
