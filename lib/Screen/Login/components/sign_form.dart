import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigo/Repository/AuthRepository.dart';
import 'package:navigo/Screen/Login/components/rounded_button.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error.dart';
import 'package:navigo/helper/keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _uid;
  bool remember = false;
  Size size;
  final List<String> errors = [];
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  goDashboard() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance
        .collection('employee')
        .doc(user.uid)
        .snapshots()
        .listen((employeeData) {
          setState(() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (employeeData.data()['isAdmin']) {
              prefs?.setString("role", "Admin");
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(adminDashboard);
            } else {
              prefs?.setString("role", "Employee");
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(employeeDashboardScreen);
            }
          });
    });
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailFormField(),
          SizedBox(height: 30),
          _buildPasswordFormField(),
          SizedBox(height: 10),
          Align(
            child: Text(
              'Forget Password?',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            alignment: Alignment.topRight,
          ),
          SizedBox(height: 10),
          FormError(errors: errors),
          SizedBox(height: 20),
          RoundedButton(
            text: "Login",
            color: kSecondaryLightColor,
            textColor: Colors.black,
            press: () async {
              KeyboardUtil.hideKeyboard(context);
              buildLoading(context);
              bool _isSignIn = await signIn(_email.trim(), _password.trim());
              if (_isSignIn) {
                goDashboard();
              } else {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: textFieldBackgroundColor,
                      content: Text(
                          'Unauthorised user',
                        style: TextStyle(
                            fontSize: 16.0, color: textColor),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                              'OK',
                            style: TextStyle(
                                fontSize: 14.0, color: kSecondaryLightColor),
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                          },
                        )
                      ],
                    ));
              }
            },
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Container _buildPasswordFormField() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        onSaved: (newValue) => _password = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            _password = value;
            removeError(error: kPassNullError);
          } else if (value.length >= 8) {
            removeError(error: kShortPassError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if (value.length < 8) {
            addError(error: kShortPassError);
            return "";
          }
          return null;
        },
        obscuringCharacter: "*",
        keyboardType: TextInputType.visiblePassword,
        focusNode: textFieldFocusNode,
        obscureText: _obscured,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Password",
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          isDense: true,
          // Reduces height a bit
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
            child: GestureDetector(
              onTap: _toggleObscured,
              child: Icon(
                _obscured
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildEmailFormField() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        onSaved: (newValue) => _email = newValue,
        onChanged: (value) {
          _email = value;
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
            return "";
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        obscureText: _obscured,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Enter your email",
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          isDense: true, // Reduces height a bit
        ),
      ),
    );
  }
}
