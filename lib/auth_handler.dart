import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';


class AuthHandler {
  OAuthProvider provider = OAuthProvider('microsoft.com');

  void handle() {
    FirebaseApp secondaryApp = Firebase.app('tqwcoviddata');
    FirebaseAuth auth = FirebaseAuth.instanceFor(app: secondaryApp);

    OAuthProvider provider = OAuthProvider('microsoft.com');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signInWithRedirect(provider);
  }

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.signInWithRedirect(provider);

     UserCredential usercred =  await FirebaseAuth.instance.getRedirectResult();

     var credent = usercred.credential;
     var token = credent!.token;


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void isLoggedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

}