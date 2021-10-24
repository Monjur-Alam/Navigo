import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final String id;

  EmployeeDetailsScreen({Key key, this.id}) : super(key: key);

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  String title = "View Employee";
  String _name;
  String _email;
  String _password;

  // For deleting history
  CollectionReference employee = FirebaseFirestore.instance.collection('employee');

  Future<void> _deleteEmployee(id) {
    return employee
        .doc(id)
        .delete()
        .then((value) => print('Employee deleted'))
        .catchError((error) => print('Failed to delete employee: $error'));
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
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: textFieldBackgroundColor,
                        title: Text(
                          'Are you sure you want to remove the employee?',
                          style: TextStyle(
                              fontSize: 16.0, color: textColor),
                        ),
                        actions: [
                          FlatButton(
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 14.0, color: textColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'REMOVE',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: kSecondaryLightColor),
                            ),
                            onPressed: () async {
                              _deleteEmployee(widget.id);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: red),
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
              .collection('employee')
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
            _email = data['email'];
            _password = data['password'];
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
                              _createEmployeeDetailsForm(),
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

  Widget _createEmployeeDetailsForm() {
    return Column(
      children: [
        SizedBox(height: 5.0),
        Container(
          child: Row(
            children: [
              Flexible(
                  child: Text(
                    'Name: ',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _name,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: new BoxDecoration(
            color: textFieldBackgroundColor,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          child: Row(
            children: [
              Flexible(
                  child: Text(
                    'Email: ',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _email,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: new BoxDecoration(
            color: textFieldBackgroundColor,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          child: Row(
            children: [
              Flexible(
                  child: Text(
                    'Password: ',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _password,
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: new BoxDecoration(
            color: textFieldBackgroundColor,
          ),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
