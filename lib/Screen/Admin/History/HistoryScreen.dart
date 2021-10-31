import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigo/Screen/Admin/History/HistoryDetailsScreen.dart';
import 'package:navigo/components/Constant.dart';

class HistoryScreen extends StatefulWidget {
  final String name;
  HistoryScreen({Key key, this.name}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  CollectionReference _history = FirebaseFirestore.instance.collection('history');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ( widget.name!= "" && widget.name!= null) ? _history.where("send_from_name", isNotEqualTo:widget.name).orderBy("send_from_name").startAt([widget.name])
            .endAt([widget.name+'\uf8ff'])
            .snapshots()
            :_history.snapshots(),
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
                return GestureDetector(
                  child: Container(
                    child: Row(children: <Widget>[
                      SvgPicture.asset(
                        "assets/icons/history_rectangle.svg",
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              backgroundColor: avatarBgColor,
                              child: Text(
                                snapshot.data.docs[index]['send_from_name']
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: kSecondaryLightColor,
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 30.0,),
                            Text(
                              snapshot.data.docs[index]['date'],
                              style: TextStyle(
                                  color: historyTitleColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data.docs[index]['time'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(15, 0, 8, 0),
                      ),
                      Container(
                        height: 100,
                        width: 1,
                        color: divider,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                                  snapshot.data.docs[index]['send_from_name'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: kSecondaryLightColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: 4,),
                            Row(
                              children: [
                                Container(
                                    child: Text(
                                      'Send To: ',
                                      style: TextStyle(
                                          color: historyTitleColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    child: Text(
                                      snapshot.data.docs[index]['send_to_name'],
                                      maxLines: 1,
                                      style: TextStyle(color: historyTextColor),
                                    )),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Row(
                              children: [
                                Container(
                                    child: Text(
                                      'Company Name: ',
                                      style: TextStyle(
                                          color: historyTitleColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    child: Text(
                                      snapshot.data.docs[index]['company'],
                                      maxLines: 1,
                                      style: TextStyle(color: historyTextColor),
                                    )),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Row(
                              children: [
                                Container(
                                    child: Text(
                                      'Email: ',
                                      style: TextStyle(
                                          color: historyTitleColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    child: Text(
                                      snapshot.data.docs[index]['send_to_email'],
                                      maxLines: 1,
                                      style: TextStyle(color: historyTextColor),
                                    )),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Row(
                              children: [
                                Container(
                                    child: Text(
                                      'Sub: ',
                                      style: TextStyle(
                                          color: historyTitleColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    child: Text(
                                      snapshot.data.docs[index]['subject'],
                                      maxLines: 2,
                                      style: TextStyle(color: historyTextColor),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(8, 12, 0, 15),
                      )
                    ]),
                    margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                    decoration: new BoxDecoration(
                      color: textFieldBackgroundColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryDetailsScreen(
                            id: storedocs[index]['id']),
                      ),
                    );
                  },
                );
              });
        });
  }
}
