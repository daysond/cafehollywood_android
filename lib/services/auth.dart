import 'package:cafe_hollywood/screens/MainTab/main_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    return _auth.currentUser != null;
  }

  String get customerID {
    return _auth.currentUser == null ? null : _auth.currentUser.uid;
  }

  String get displayName {
    return _auth.currentUser.displayName ?? '';
  }

  String get phoneNumber {
    return _auth.currentUser.phoneNumber ?? '';
  }

  String _currentUID(User? user) {
    return user != null ? user.uid : null;
  }

  Stream<String> get currentUserID {
    return _auth.authStateChanges().map(_currentUID);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user.uid;
    } catch (error) {
      print('error signing in ${error.toString()}');
      // print(error.toString());
      return null;
    }
  }

  Future signInWithPhone() async {}

  Future signOut() async {
    _auth.signOut();
  }

  Future createUserWithPhone(
      String phone, String? displayName, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            Navigator.of(context).pop(); // to pop the dialog box
            Navigator.of(context).pushReplacementNamed('/home');
          }).catchError((e) {
            // return e.toString();
            print(e.toString());
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.toString());
        },
        codeSent: (String verificationId, int forceResendingToken) {
          final _codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("Enter Verification Code From Text Message"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[TextField(controller: _codeController)],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("submit"),
                  textColor: Colors.white,
                  color: Colors.black,
                  onPressed: () {
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: _codeController.text.trim());
                    _auth
                        .signInWithCredential(_credential)
                        .then((UserCredential result) {
                      if (displayName != null) {
                        _auth.currentUser
                            .updateProfile(displayName: displayName);
                      }

                      Navigator.of(context).pop(); // to pop the dialog box
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MainTabBar()));
                      // Navigator.of(context).pushReplacementNamed('/home');
                    }).catchError((e) {
                      return "error";
                    });
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }
}
