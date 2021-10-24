import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigo/Screen/Admin/AdminDashboard.dart';
import 'package:navigo/Screen/Admin/AdminDeshboardScreen.dart';
import 'package:navigo/Screen/AnimatedSplashScreen.dart';
import 'package:navigo/Screen/Employee/EmployeeDashboardScreen.dart';
import 'package:navigo/Screen/Login/LoginScreen.dart';

import 'components/Constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // CHeck for Errors
        if (snapshot.hasError) {
          print("Something went Wrong");
        }
        // once Completed, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Navigo',
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(),
            routes: <String, WidgetBuilder>{
              loginScreen: (BuildContext context) => LoginScreen(),
              adminDashboard: (BuildContext context) => AdminDashboard(),
              employeeDashboardScreen: (BuildContext context) => EmployeeDashboardScreen()
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}