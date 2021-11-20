
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password is too week.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already use for that gmail');
    }
    return false;
  }
}

Future<bool> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  } on FirebaseAuthException catch(e) {
    print(e);
    return false;
  }
}