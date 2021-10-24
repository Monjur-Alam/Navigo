import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error.dart';

class CreateTaskForm extends StatefulWidget {

  @override
  _CreateTaskFormState createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {

  final _formKey = GlobalKey<FormState>();
  String _name;
  String _subject;
  String _text;
  bool _remember = false;
  final List<String> _errors = [];

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            // child: Row(
            //   children: <Widget>[
            //     Text(
            //         'Text',
            //         style: TextStyle(
            //         color: Colors.grey
            //       ),
            //     ),
            //     TextField(
            //
            //     )
            //
            //   ],
            // ),
            color: textFieldBackgroundColor,
          ),
          _buildNameFormField(),
          SizedBox(height: 30),
          FormError(errors: _errors),
        ],
      ),
    );
  }

  TextFormField _buildNameFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: nameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: nameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter task name",
        filled: true,
        fillColor: textFieldBackgroundColor,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
