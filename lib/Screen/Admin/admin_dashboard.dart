import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigo/Screen/Admin/Contact/AddContactScreen.dart';
import 'package:navigo/Screen/Admin/Employee/AddEmployeeScreen.dart';
import 'package:navigo/Screen/Admin/Contact/ContactListScreen.dart';
import 'package:navigo/Screen/Admin/History/HistoryScreen.dart';
import 'package:navigo/Screen/Admin/Task/CreateTaskScreen.dart';
import 'package:navigo/Screen/Admin/Employee/EmployeeListScreen.dart';
import 'package:navigo/Screen/Admin/History/HistoryDetailsScreen.dart';
import 'package:navigo/Screen/Admin/Task/TaskListScreen.dart';
import 'package:navigo/components/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _appBarTitle = "Task List";
  String _userName = "Username";
  String _email = "abc@gmail.com";
  String _name = 's';
  Icon cusIcon = const Icon(Icons.search);
  Widget cusSearchBar = const Text("Task List");
  int _selectedIndex = 0;
  bool _isTitle = false;
  bool _isFAB = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  final List<Widget> _widgetOptions = <Widget>[
    TaskListScreen(),
    EmployeeListScreen(),
    ContactListScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _isTitle = false;
        _isFAB = true;
        _appBarTitle = "Task List";
      } else if (index == 1) {
        _isTitle = false;
        _isFAB = true;
        _appBarTitle = "Employee List";
      } else if (index == 2) {
        _isTitle = false;
        _isFAB = true;
        _appBarTitle = "Contact List";
      } else if (index == 3) {
        _isTitle = false;
        _isFAB = false;
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
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isTitle = true;
                if (cusIcon.icon == Icons.search) {
                  cusIcon = const Icon(Icons.cancel);
                  cusSearchBar = TextField(
                    controller: _searchQuery,
                    onChanged: (value) {
                      _name = value;
                      // TaskListScreen(name: value,);
                    },
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(color: textColor)),
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  );
                } else {
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
        child: _widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        selectedItemColor: kSecondaryLightColor,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _isFAB
          ? FloatingActionButton(
        backgroundColor: kSecondaryLightColor,
        foregroundColor: Colors.black,
        child: const ImageIcon(
          AssetImage("assets/icons/add.png"),
        ),
        onPressed: () {
          switch (_selectedIndex) {
            case 0:
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateTaskScreen(),
                  ));
              break;
            case 1:
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddEmployeeScreen(),
                  ));
              break;
            case 2:
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddContactScreen(),
                  ));
              break;
            case 3:
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HistoryDetailsScreen(),
                  ));
              break;
          }
        },
      )
          : null,
      bottomSheet: const Padding(padding: EdgeInsets.only(bottom: 45.0)),
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
      setState(() {
        _userName = employeeData.data()['name'];
        _email = employeeData.data()['email'];
      });
    });
  }

  Widget _drawerMenu() {
    return Drawer(
        child: Container(
            color: Colors.black,
            child: ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _userName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                        color: kSecondaryLightColor,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                accountName: Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ),
                accountEmail: Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/header_bg.png"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                title: const Text(
                  'EMPLOYEE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/employee.svg",
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedIndex = 1;
                    _isTitle = false;
                    _isFAB = true;
                    _appBarTitle = "Employee List";
                  });
                },
              ),
              ListTile(
                title: const Text(
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
                    _selectedIndex = 2;
                    _isTitle = false;
                    _isFAB = true;
                    _appBarTitle = "Contact List";
                  });
                },
              ),
              ListTile(
                title: const Text(
                  'HISTORY',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/history.svg",
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).pop();
                    _selectedIndex = 3;
                    _isTitle = false;
                    _isFAB = false;
                    _appBarTitle = "History";
                  });
                },
              ),
              ListTile(
                title: const Text(
                  'SETTING',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/setting.svg",
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: SvgPicture.asset(
                  "assets/icons/logout.svg",
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: textFieldBackgroundColor,
                        title: const Text(
                          'Are you sure want to log out?',
                          style: TextStyle(
                              fontSize: 16.0, color: textColor),
                        ),
                        actions: [
                          FlatButton(
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 14.0, color: textColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: const Text(
                              'LOG OUT',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: kSecondaryLightColor),
                            ),
                            onPressed: () async {
                              final prefs =
                              await SharedPreferences.getInstance();
                              prefs.remove('role');
                              prefs.remove('username');
                              prefs.remove('email');
                              Navigator.of(context).pop();
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
}
