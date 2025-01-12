import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> registerNewUser(
      String email, String password, String username) async {
    String res = 'somthing went wrong';
    try {
      UserCredential _userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore
          .collection('names')
          .doc(_userCredentials.user!.uid)
          .set({
        'fullName': username,
        'email': email,
        'uid': _userCredentials.user!.uid,
      });
      res = 'success';
    } catch (e) {}
    return res;
  }

  Future<String> loginuser(String email, String password) async {
    String res = "something went wrong";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
