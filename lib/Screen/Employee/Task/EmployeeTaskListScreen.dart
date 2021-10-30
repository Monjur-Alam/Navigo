import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigo/Screen/Employee/Task/SendEmailScreen.dart';
import 'package:navigo/components/Constant.dart';

class EmployeeTaskListScreen extends StatefulWidget {
  final String name;
  EmployeeTaskListScreen({Key key, this.name}) : super(key: key);

  @override
  _EmployeeTaskListScreenState createState() => _EmployeeTaskListScreenState();
}

class _EmployeeTaskListScreenState extends State<EmployeeTaskListScreen> {

  CollectionReference task = FirebaseFirestore.instance.collection('task');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ( widget.name!= "" && widget.name!= null) ? task.where("name", isNotEqualTo:widget.name).orderBy("name").startAt([widget.name])
            .endAt([widget.name+'\uf8ff'])
            .snapshots()
            :task.snapshots(),
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
                return Column(
                  children: <Widget>[
                    ListTile(
                      tileColor: listItemColor,
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
                        'Sub: ' + snapshot.data.docs[index]['subject'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textColor, fontSize: 14.0),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendEmailScreen(
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
                );
              });
        });
  }
}
