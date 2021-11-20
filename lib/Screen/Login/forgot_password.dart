import 'package:flutter/material.dart';
import 'package:navigo/Screen/Login/components/forgot_pass_form.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
                            'Reset Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            'Enter your registered email address below to change your Navigo account password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 80.0,),
                          ForgotPassForm(),
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
