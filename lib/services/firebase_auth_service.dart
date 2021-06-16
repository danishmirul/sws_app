import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sws_app/screens/bluetooth/device_list_screen.dart';
import 'package:sws_app/screens/sign_in/sign_in_screen.dart';

import '../models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  //Handle Authentication
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        return snapshot.hasData ? DeviceListScreen() : SignInScreen();
      },
    );
  }

  FirebaseAuthService({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    return User(
      uid: user.uid,
      email: user.email,
    );
  }

  Stream<User> get onAuthStateChanged {
    try {
      return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signInEmailPassword(String email, String password) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signUpEmailPassword(
      {@required String email, @required String password}) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> resetPassword({@required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signInAnonymously() async {
    try {
      final authResult = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return _firebaseAuth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> currentUser() async {
    try {
      final user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
