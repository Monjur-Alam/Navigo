import 'package:flutter/material.dart';
import 'package:navigo/Repository/AuthRepository.dart';
import 'package:navigo/Screen/Login/components/rounded_button.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error.dart';
import 'package:navigo/components/login_form_error_dark.dart';
import 'package:navigo/helper/keyboard.dart';

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _uid;
  bool remember = false;
  final List<String> errors = [];
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailFormField(),
          SizedBox(height: 10),
          LoginFormErrorDark(errors: errors),
          SizedBox(height: 20),
          RoundedButton(
            text: "Reset",
            color: kSecondaryLightColor,
            textColor: Colors.black,
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                buildLoading(context);
                bool isReset = await resetPassword(_email.trim());
                if (isReset) {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: textFieldBackgroundColor,
                        title: Text(
                          'Password reset email link is been send, please check.',
                          style: TextStyle(fontSize: 16.0, color: textColor),
                        ),
                        actions: [
                          FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: kSecondaryLightColor),
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.of(context)
                                  .pushReplacementNamed(loginScreen);
                            },
                          )
                        ],
                      ));
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: textFieldBackgroundColor,
                        title: Text(
                          'Error in email reset.',
                          style: TextStyle(fontSize: 16.0, color: textColor),
                        ),
                        actions: [
                          FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: kSecondaryLightColor),
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            },
                          )
                        ],
                      ));
                }
              }
            },
          ),
          SizedBox(height: 100),
        ],
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
          errorStyle: TextStyle(height: 0),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          isDense: true, // Reduces height a bit
        ),
      ),
    );
  }
}
