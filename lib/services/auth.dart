import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCreds = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCreds.user;
  }

  Future<User?> signInAnonymously() async {
    final userCreds = await _firebaseAuth.signInAnonymously();
    return userCreds.user;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCreds = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return userCreds.user;
  }

  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final accessToken = res.accessToken;
        UserCredential userCreds = await FirebaseAuth.instance
            .signInWithCredential(
                FacebookAuthProvider.credential(accessToken!.token));
        return userCreds.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: res.error!.developerMessage);
    }
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        UserCredential userCreds =
            await _firebaseAuth.signInWithCredential(authCredential);
        return userCreds.user;
      } else {
        throw FirebaseAuthException(code: 'ERROR_MISSING_ID_TOKEN');
      }
    } else {
      throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER');
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FacebookLogin().logOut();
    await _firebaseAuth.signOut();
  }
}
