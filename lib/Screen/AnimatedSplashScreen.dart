import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  var materialColor = Color(0xFFFFFFFF);

  AnimationController _controller;
  String role;

  @override
  void initState() {
    super.initState();
    startTime();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )
      ..repeat();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (role == 'Admin') {
      Navigator.of(context).pushReplacementNamed(adminDashboard);
    } else if (role == 'Employee') {
      Navigator.of(context).pushReplacementNamed(employeeDashboardScreen);
    } else {
      Navigator.of(context).pushReplacementNamed(loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: _buildBody(),
        )
      ],
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _backgroundImage(),
            _buildContainer(150 * _controller.value),
            _buildContainer(200 * _controller.value),
            _buildContainer(250 * _controller.value),
            _buildContainer(300 * _controller.value),
            _buildContainer(350 * _controller.value),
            Align(
              child: Image.asset(
                'assets/images/splash_logo.jpg',
                height: 40.0,
                width: 100.0,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: materialColor.withOpacity(1 - _controller.value),
      ),
    );
  }

  Widget _backgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash_bg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
