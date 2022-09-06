import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  Future<User?> signInAnonymously();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> signInWithFacebook();

  Future<User?> signInWithGoogle();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCreds = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCreds.user;
  }

  @override
  Future<User?> signInAnonymously() async {
    final userCreds = await _firebaseAuth.signInAnonymously();
    return userCreds.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCreds = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return userCreds.user;
  }

  @override
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

  @override
  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      UserCredential userCreds =
          await _firebaseAuth.signInWithCredential(authCredential);
      return userCreds.user;
    } else {
      throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER');
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
