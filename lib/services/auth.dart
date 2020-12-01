import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _currentUID(User? user) {
    return user != null ? user.uid : throw ArgumentError('user does not exist');
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
}
