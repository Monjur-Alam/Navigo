import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigo/Screen/Login/components/sign_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _backgroundImage(),
        _bottomBackgroundImage(),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: _buildBody()
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: CustomScrollView(
        reverse: true,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.0,),
                          Text(
                            'Login Now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            'Please enter the details below to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 80.0,),
                          SignForm(),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_bg_dark.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _bottomBackgroundImage() {
    return Align(
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_bottom_bg.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      alignment: AlignmentDirectional.bottomCenter,
    );
  }
}
