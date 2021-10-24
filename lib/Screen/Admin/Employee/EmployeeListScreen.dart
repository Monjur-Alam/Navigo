import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:navigo/Screen/Admin/Employee/EmployeeDetailsScreen.dart';
import 'package:navigo/components/Constant.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final Stream<QuerySnapshot> employeeStream =
      FirebaseFirestore.instance.collection('employee').snapshots();

  // For deleting employee
  CollectionReference employee =
      FirebaseFirestore.instance.collection('employee');

  Future<void> _deleteEmployee(id) {
    return employee
        .doc(id)
        .delete()
        .then((value) => print('Employee deleted'))
        .catchError((error) => print('Failed to delete employee: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: employeeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();

          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          tileColor: listItemColor,
                          leading: CircleAvatar(
                            backgroundColor: avatarBgColor,
                            child: Text(
                              snapshot.data.docs[index]['name'].toString().substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                  color: kSecondaryLightColor,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            snapshot.data.docs[index]['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: kSecondaryLightColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Email: ' + snapshot.data.docs[index]['email'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: textColor, fontSize: 14.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeDetailsScreen(
                                    id: storedocs[index]['id']),
                              ),
                            );
                          },
                        )
                      ]
                          .map(
                            (e) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          child: e,
                        ),
                      )
                          .toList(),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: textFieldBackgroundColor,
                                title: Text(
                                  'Are you sure you want to remove the Employee?',
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
                                      _deleteEmployee(storedocs[index]['id']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                        },
                      ),
                    ]
                );
              });
        });
  }
}
