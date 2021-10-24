

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> addEmployee(String _name, String _email, String _password, bool _isAdmin) async {
  DocumentReference employeeRef;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user = _firebaseAuth.currentUser;
  employeeRef = _db.collection('employee').doc(user.uid);

  if ((await employeeRef.get()).exists) {
    return false;
  } else {
    employeeRef.set({'name': _name, 'email': _email, 'password': _password, 'isAdmin': _isAdmin});
    return true;
  }
}