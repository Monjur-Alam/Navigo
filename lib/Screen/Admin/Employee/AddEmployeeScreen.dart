import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigo/Repository/AuthRepository.dart';
import 'package:navigo/Repository/FirestoreRepository.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error_dark.dart';
import 'package:navigo/helper/keyboard.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  String title = "Add Employee";
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;
  String _confirmedPassword;
  final List<String> _errors = [];
  final _passwordFocusNode = FocusNode();
  final _confirmedPasswordFocusNode = FocusNode();
  bool _obscuredPassword = false;
  bool _obscuredConfirmedPassword = false;

  void addError({String error}) {
    if (!_errors.contains(error))
      setState(() {
        _errors.add(error);
      });
  }

  void _toggleObscuredPassword() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;
      if (_passwordFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      _passwordFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscuredConfirmedPassword() {
    setState(() {
      _obscuredConfirmedPassword = !_obscuredConfirmedPassword;
      if (_confirmedPasswordFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      _confirmedPasswordFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void removeError({String error}) {
    if (_errors.contains(error))
      setState(() {
        _errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {Navigator.pop(context, true)},
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(title),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    KeyboardUtil.hideKeyboard(context);
                    bool isSignUp =
                        await signUp(_email.trim(), _password.trim());
                    bool isAddEmployee = await addEmployee(_name, _email, _password, false);
                    if (isSignUp && isAddEmployee) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: textFieldBackgroundColor,
                                title: Text(
                                  'Create employee account successful.',
                                  style: TextStyle(
                                      fontSize: 16.0, color: textColor),),
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
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: textFieldBackgroundColor,
                                content: Text(
                                    'The account already use for that gmail.',
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
                                    },
                                  )
                                ],
                              ));
                    }
                    // Navigator.of(context).pushReplacementNamed(loginScreen);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: kSecondaryLightColor),
                ))
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Container(
          color: bgColor,
        ),
        CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          _addEmployeeForm(),
                        ],
                      )),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _addEmployeeForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 5.0),
          FormErrorDark(errors: _errors),
          SizedBox(height: 5.0),
          Container(
            child: _buildNameFormField(),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: new BoxDecoration(
              color: textFieldBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: _buildEmailFormField(),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: new BoxDecoration(
              color: textFieldBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: _buildPasswordFormField(),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: new BoxDecoration(
              color: textFieldBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: _buildConfirmedPasswordFormField(),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: new BoxDecoration(
              color: textFieldBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }

  TextFormField _buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {
        _name = value;
        if (value.isNotEmpty) {
          removeError(error: employeeNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: employeeNameNullError);
          return "";
        }
        return null;
      },
      cursorColor: kSecondaryLightColor,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter employee name",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        icon: Text(
          'Name',
          style: TextStyle(color: textColor),
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }

  TextFormField _buildEmailFormField() {
    return TextFormField(
      onSaved: (newValue) => _email = newValue,
      onChanged: (value) {
        _email = value;
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      cursorColor: kSecondaryLightColor,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter email address",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        icon: Text(
          'Email',
          style: TextStyle(color: textColor),
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }

  TextFormField _buildPasswordFormField() {
    return TextFormField(
      onSaved: (newValue) => _password = newValue,
      onChanged: (value) {
        _password = value;
        if (value.isNotEmpty) {
          _password = value;
          removeError(error: kPassNullError);
        }
        if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      obscuringCharacter: "*",
      keyboardType: TextInputType.visiblePassword,
      focusNode: _passwordFocusNode,
      obscureText: _obscuredPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        icon: Text(
          'Password',
          style: TextStyle(color: textColor),
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: GestureDetector(
            onTap: _toggleObscuredPassword,
            child: Icon(
              _obscuredPassword
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildConfirmedPasswordFormField() {
    return TextFormField(
      onSaved: (newValue) => _confirmedPassword = newValue,
      onChanged: (value) {
        _confirmedPassword = value;
        if (value.isNotEmpty) {
          removeError(error: kConfirmedPasswordNullError);
        }
        if (value == _password) {
          removeError(error: kMatchPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kConfirmedPasswordNullError);
          return "";
        }
        if (value != _password) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      focusNode: _confirmedPasswordFocusNode,
      obscuringCharacter: "*",
      cursorColor: kSecondaryLightColor,
      obscureText: _obscuredConfirmedPassword,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Confirmed password",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        icon: Text(
          'Confirmed Password',
          style: TextStyle(color: textColor),
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: GestureDetector(
            onTap: _toggleObscuredConfirmedPassword,
            child: Icon(
              _obscuredConfirmedPassword
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
