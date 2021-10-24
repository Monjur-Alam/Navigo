import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error_dark.dart';
import 'package:navigo/helper/keyboard.dart';

class EditTaskScreen extends StatefulWidget {
  final String id;

  EditTaskScreen({Key key, this.id}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  String title = "Edit Task";
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _subject;
  String _text;
  String _signature;
  final List<String> _errors = [];

  // create task
  CollectionReference task = FirebaseFirestore.instance.collection('task');

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateTask() {
    return task
        .doc(widget.id)
        .update({
          'name': _name,
          'subject': _subject,
          'text': _text,
          'signature': _signature
        })
        .then((value) => print('Task updated'))
        .catchError((error) => print('Failed to update task: $error'));
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
                    _updateTask();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: textFieldBackgroundColor,
                              content: Text(
                                  'Updated task successful.',
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
                child: Text(
                  'Update',
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
        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('task')
              .doc(widget.id)
              .get(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              print('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data.data();
            _name = data['name'];
            _subject = data['subject'];
            _text = data['text'];
            _signature = data['signature'];
            return CustomScrollView(
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
                              _createTaskForm(),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _createTaskForm() {
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
            child: _buildSubjectFormField(),
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
                    'Text',
                    style: TextStyle(color: textColor),
                  ),
                ),
                _buildTextFormField()
              ],
            ),
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
                    'Email Signature',
                    style: TextStyle(color: textColor),
                  ),
                ),
                _buildSignatureFormField()
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
      initialValue: _name,
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {
        _name = value;
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
      cursorColor: kSecondaryLightColor,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter task name",
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

  TextFormField _buildSubjectFormField() {
    return TextFormField(
      initialValue: _subject,
      onSaved: (newValue) => _subject = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _subject = value;
          removeError(error: subjectNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: subjectNullError);
          return "";
        }
        return null;
      },
      cursorColor: kSecondaryLightColor,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Enter task subject",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        icon: Text(
          'Subject',
          style: TextStyle(color: textColor),
        ),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }

  TextFormField _buildTextFormField() {
    return TextFormField(
      initialValue: _text,
      onSaved: (newValue) => _text = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _text = value;
          removeError(error: textNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: textNullError);
          return "";
        }
        return null;
      },
      cursorColor: kSecondaryLightColor,
      style: TextStyle(color: Colors.white),
      minLines: 10,
      maxLines: 100,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: "Enter task body",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }

  TextFormField _buildSignatureFormField() {
    return TextFormField(
      initialValue: _signature,
      onSaved: (newValue) => _signature = newValue,
      onChanged: (value) {
        _signature = value;
        if (value.isNotEmpty) {
          removeError(error: signatureNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: signatureNullError);
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
        hintText: "Enter your Signature",
        hintStyle: TextStyle(fontSize: 16.0, color: textColor),
        errorStyle: TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixStyle: TextStyle(color: textColor),
      ),
    );
  }
}
