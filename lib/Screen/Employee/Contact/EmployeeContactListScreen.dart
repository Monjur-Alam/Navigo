import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';

class EmployeeContactListScreen extends StatefulWidget {

  @override
  _EmployeeContactListScreenState createState() => _EmployeeContactListScreenState();
}

class _EmployeeContactListScreenState extends State<EmployeeContactListScreen> {
  final Stream<QuerySnapshot> contactStream =
  FirebaseFirestore.instance.collection('contact').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: contactStream,
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
                        'Company: ' + snapshot.data.docs[index]['company'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textColor, fontSize: 14.0),
                      ),
                      onTap: () {},
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
