import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttracker/screens/auth/sign_in.dart';
import 'package:ttracker/screens/home/homescreen.dart';
import 'package:ttracker/services/auth_provider.dart';
import 'package:ttracker/services/database.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const SignInScreen();
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: auth.currentUser!.uid),
            child: const HomeScreen(),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
