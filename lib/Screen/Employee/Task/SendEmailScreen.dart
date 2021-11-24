import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:navigo/Repository/EmailRepository.dart';
import 'package:navigo/Screen/Admin/Contact/ContactListScreen.dart';
import 'package:navigo/components/Constant.dart';
import 'package:navigo/components/form_error_dark.dart';
import 'package:navigo/helper/keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendEmailScreen extends StatefulWidget {
  final String id;

  SendEmailScreen({Key key, this.id}) : super(key: key);

  @override
  _SendEmailScreenState createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  String title = "Send Email";
  final _formKey = GlobalKey<FormState>();
  String _uid;
  String _username;
  String _toName;
  String _toCompany;
  String _email;
  String _subject;
  String _text;
  String _signature;
  final List<String> _errors = [];
  CollectionReference _ownHistory;
  DateTime now = DateTime.now();
  String _formattedTime;
  String _formattedDate;
  String _searchToEmail = '';
  TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
    _getUid();
    _formattedTime = DateFormat('kk:mm').format(now);
    _formattedDate = DateFormat('EEE d MMM').format(now);
  }

  _getUid() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User user = _firebaseAuth.currentUser;
    _uid = user.uid.toString();
    _ownHistory = FirebaseFirestore.instance.collection(_uid);
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
  }

  // create history
  CollectionReference adminHistory =
      FirebaseFirestore.instance.collection('history');

  CollectionReference contact =
      FirebaseFirestore.instance.collection('contact');

  Future<void> _saveToOwnHistory() {
    return _ownHistory
        .add({
          'send_from_name': _username,
          'send_to_name': _toName,
          'send_to_email': _email,
          'subject': _subject,
          'text': _text,
          'signature': _signature,
          'time': _formattedTime,
          'date': _formattedDate,
          'company': _toCompany
        })
        .then((value) => print('Task Created'))
        .catchError((error) => print('Failed to create task: $error'));
  }

  Future<void> _saveToAdminHistory() {
    return adminHistory
        .add({
          'send_from_name': _username,
          'send_to_name': _toName,
          'send_to_email': _email,
          'subject': _subject,
          'text': _text,
          'signature': _signature,
          'time': _formattedTime,
          'date': _formattedDate,
          'company': _toCompany
        })
        .then((value) => print('Task Created'))
        .catchError((error) => print('Failed to create task: $error'));
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
                  if (_formKey.currentState.validate() && _email != null) {
                    _formKey.currentState.save();
                    KeyboardUtil.hideKeyboard(context);
                    sendEmail(
                        username: _username,
                        name: _signature,
                        email: _email,
                        subject: _subject,
                        message: _text,
                        signature: _signature);
                    _saveToAdminHistory();
                    _saveToOwnHistory();
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              backgroundColor: textFieldBackgroundColor,
                              content: Text(
                                'Send email successful.',
                                style:
                                    TextStyle(fontSize: 16.0, color: textColor),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: kSecondaryLightColor),
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
                child: SvgPicture.asset(
                  "assets/icons/send.svg",
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
          InkWell(
            onTap: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Scaffold(
                        backgroundColor: Colors.black87,
                        body: _ContactDialog() //Put your screen design here!
                        ),
              );
            },
            child: Container(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                      child: Text(
                    'Send To',
                    style: TextStyle(color: textColor),
                  )),
                  SizedBox(width: 15.0),
                  Container(
                    child: _email != null
                        ? FDottedLine(
                            color: signatureBackgroundColor,
                            height: 0.0,
                            strokeWidth: 1.0,
                            dottedLength: 8.0,
                            space: 0.0,
                            corner: FDottedLineCorner.all(30),
                            child: Container(
                              color: textFieldBackgroundColor,
                              height: 25,
                              alignment: Alignment.center,
                              child: Text(
                                _email,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            ),
                          )
                        : Text(
                            'abc@example.com',
                            style: TextStyle(color: textColor, fontSize: 14.0),
                          ),
                    decoration: new BoxDecoration(
                      color: textFieldBackgroundColor,
                    ),
                  ),
                  SizedBox(width: 15.0),
                  // Flexible(child: SvgPicture.asset("assets/icons/contact.svg"))
                ],
              ),
              padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: new BoxDecoration(
                color: textFieldBackgroundColor,
              ),
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
                    style: TextStyle(color: avatarBgColor),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _signature,
                    style: TextStyle(color: avatarBgColor),
                  ),
                ),
                SizedBox(height: 12.0),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: new BoxDecoration(
              color: signatureBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            child: FDottedLine(
              color: signatureBackgroundColor,
              height: 100.0,
              strokeWidth: 1.0,
              dottedLength: 8.0,
              space: 3.0,
              corner: FDottedLineCorner.all(10),
              child: Container(
                color: textFieldBackgroundColor,
                height: 100,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/file_uploaded_icon.svg",
                    ),
                    SizedBox(height: 12.0),
                    Text("Upload File", style: TextStyle(color: avatarBgColor)),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
              ),
            ),
            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
            decoration: new BoxDecoration(
              color: textFieldBackgroundColor,
            ),
          ),
          SizedBox(height: 5.0),
        ],
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

  _ContactDialog() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context, true)},
          icon: Icon(Icons.arrow_back),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           _searchQuery = null;
        //           _searchToEmail = '';
        //         });
        //       },
        //       icon: const Icon(Icons.cancel)),
        // ],
        title: TextField(
          autofocus: true,
          controller: _searchQuery,
          onChanged: (value) {
            getContactList(_searchToEmail);
            // setState(() {
            //   _searchToEmail = value;
            //   print(_searchToEmail);
            // });
          },
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search...",
              hintStyle: TextStyle(color: textColor)),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: getContactList(_searchToEmail),
      ),
      backgroundColor: bgColor,
    );
  }

  Widget getContactList(String _searchToEmail) {
    return StreamBuilder<QuerySnapshot>(
        stream: (_searchToEmail != "" && _searchToEmail != null)
            ? contact
                .where("name", isNotEqualTo: _searchToEmail)
                .orderBy("name")
                .startAt([_searchToEmail]).endAt(
                    [_searchToEmail + '\uf8ff']).snapshots()
            : contact.snapshots(),
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
                          snapshot.data.docs[index]['name']
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
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
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _email = snapshot.data.docs[index]['email'];
                          _toName = snapshot.data.docs[index]['name'];
                          _toCompany = snapshot.data.docs[index]['company'];
                        });
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
