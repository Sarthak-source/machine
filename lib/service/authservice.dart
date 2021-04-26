import 'package:firebase_auth/firebase_auth.dart';
import 'package:machineweb/model/models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUser?> user() {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      user.sendEmailVerification();

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  bool? isemailVarified() {
    try {
      return _auth.currentUser!.emailVerified |
          (_auth.currentUser!.providerData[0].providerId == 'phone');
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future sendVarificationEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future deleteProfile() async {
    try {
      return await _auth.currentUser!.delete();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
