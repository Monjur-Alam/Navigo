import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:navigo/components/Constant.dart';

import 'EditTaskScreen.dart';

class TaskListScreen extends StatefulWidget {
  final String name;
  TaskListScreen({Key key, this.name}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  // For deleting employee
  CollectionReference task = FirebaseFirestore.instance.collection('task');

  Future<void> _deleteTask(id) {
    return task
        .doc(id)
        .delete()
        .then((value) => print('Task deleted'))
        .catchError((error) => print('Failed to delete task: $error'));
  }

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
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Column(
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
                              builder: (context) => EditTaskScreen(
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
                      caption: 'Edit',
                      color: Colors.black45,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(
                                id: storedocs[index]['id']),
                          ),
                        );
                      },
                    ),
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
                                'Are you sure you want to remove the Task?',
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
                                    _deleteTask(storedocs[index]['id']);
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
