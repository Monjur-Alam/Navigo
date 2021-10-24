import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigo/components/Constant.dart';

class HistoryDetailsScreen extends StatefulWidget {
  final String id;
  HistoryDetailsScreen({Key key, this.id}) : super(key: key);

  @override
  _HistoryDetailsScreenState createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  String title = "View History";
  String _sendFromName;
  String _sendToName;
  String _sendToEmail;
  String _subject;
  String _text;
  String _signature;

  // For deleting history
  CollectionReference contact = FirebaseFirestore.instance.collection('history');

  Future<void> _deleteHistory(id) {
    return contact
        .doc(id)
        .delete()
        .then((value) => print('History deleted'))
        .catchError((error) => print('Failed to delete history: $error'));
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
                          'Are you sure you want to remove the Contact?',
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
                              _deleteHistory(widget.id);
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
              .collection('history')
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
            _sendFromName = data['send_from_name'];
            _sendToName = data['send_to_name'];
            _sendToEmail = data['send_to_email'];
            _subject = data['subject'];
            _text = data['text'];
            _signature = data['signature'];
            print(_sendFromName);
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
                              _createHistoryForm(),
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

  Widget _createHistoryForm() {
    return Column(
      children: [
        SizedBox(height: 5.0),
        Container(
          child: Row(
            children: [
              Flexible(
                  child: Text(
                    'Send From',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _sendFromName,
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
                    'Send To',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _sendFromName,
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
                    'Email',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _sendToEmail,
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
                    'Subject',
                    style: TextStyle(color: textColor),
                  )),
              SizedBox(width: 15.0),
              Flexible(
                  child: Text(
                    _subject,
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
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _text,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              SizedBox(height: 12.0),
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
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _signature,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              SizedBox(height: 12.0),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: new BoxDecoration(
            color: textFieldBackgroundColor,
          ),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
