import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ttracker/screens/homescreen.dart';
import 'package:ttracker/screens/sign_in.dart';
import 'package:ttracker/services/auth.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const SignInScreen();
          } else {
            return const HomeScreen();
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
