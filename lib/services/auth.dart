import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rcapp/models/user.dart';
import 'package:rcapp/services/database.dart';

var isAdminglobal = false;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user object based on firebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in anon
  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;

  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: (email), password: (password));
      FirebaseUser user = result.user;

      var userkaabba = (await FirebaseAuth.instance.currentUser()).uid;
      var dat = await Firestore.instance
          .collection("userInfo")
          .document(userkaabba)
          .get()
          .then((value) => value.data["isAdmin"]);

      final FirebaseMessaging _messaging = FirebaseMessaging();
      var token = await _messaging.getToken();

      await Firestore.instance
          .collection('userInfo')
          .document(userkaabba)
          .updateData({'token': token});
      var _tokendata = await Firestore.instance
          .collection('confirmedOrders')
          .where('id', isEqualTo: userkaabba)
          .getDocuments();

      _tokendata.documents.forEach((element) {
        Firestore.instance
            .collection('confirmedOrders')
            .document('${element.data["_date"]}')
            .updateData({'token': token});
      });

      isAdminglobal = dat;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(
      String name, bool isAuth, String number, String password) async {
    try {
      String numemail = number + "@gmail.com";
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: (numemail), password: (password));
      FirebaseUser user = result.user;

      final FirebaseMessaging _messaging = FirebaseMessaging();
      var token = await _messaging.getToken();

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('chowmin', 100, 10);
      await DatabaseService(uid: user.uid)
          .updateUserInfo('$name', isAuth, '$number', token);

      var userkaabba = user.uid;
      var dat = await Firestore.instance
          .collection("userInfo")
          .document(userkaabba)
          .get()
          .then((value) => value.data["isAdmin"]);

      isAdminglobal = dat;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
