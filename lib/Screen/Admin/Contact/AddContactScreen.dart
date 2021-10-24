import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error_dark.dart';
import 'package:navigo/helper/keyboard.dart';

class AddContactScreen extends StatefulWidget {

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  String title = "Add Contact";
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _company;
  String _additionalInfo;
  final List<String> _errors = [];

  // Adding contact
  CollectionReference contact = FirebaseFirestore.instance.collection('contact');

  Future<void> _addContact() {
    return contact
        .add({
      'name': _name,
      'email': _email,
      'company': _company,
      'additionalInfo': _additionalInfo
    })
        .then((value) => print('Contact Added'))
        .catchError((error) => print('Failed to Add contact: $error'));
  }

  void addError({String error}) {
    if (!_errors.contains(error))
      setState(() {
        _errors.add(error);
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
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    KeyboardUtil.hideKeyboard(context);
                    _addContact();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: textFieldBackgroundColor,
                          content:
                          Text(
                              'Create contact successful.',
                            style: TextStyle(
                                fontSize: 16.0, color: textColor),
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                  'Ok',
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
            child: _buildCompanyNameFormField(),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: new BoxDecoration(
              color: textFieldBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: Column(
              children: [
                SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Additional Information',
                    style: TextStyle(color: textColor),
                  ),
                ),
                _buildAdditionalInfoFormField()
              ],
            ),
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

  TextFormField _buildCompanyNameFormField() {
    return TextFormField(
      onSaved: (newValue) => _company = newValue,
      onChanged: (value) {
        _company = value;
        if (value.isNotEmpty) {
          removeError(error: companyNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: companyNameNullError);
          return "";
        }
        return null;
      },
      cursorColor: kSecondaryLightColor,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "ABC",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        icon: Text(
          'Company Name',
          style: TextStyle(color: textColor),
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }

  TextFormField _buildAdditionalInfoFormField() {
    return TextFormField(
      onSaved: (newValue) => _additionalInfo = newValue,
      onChanged: (value) {
        _additionalInfo = value;
        if (value.isNotEmpty) {
          removeError(error: additionalInfoNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: additionalInfoNullError);
          return "";
        }
        return null;
      },
      cursorColor: kSecondaryLightColor,
      style: TextStyle(color: Colors.white),
      minLines: 5,
      maxLines: 100,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: "Enter additional info",
        hintStyle: TextStyle(
            fontSize: 16.0, color: textColor
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }
}
