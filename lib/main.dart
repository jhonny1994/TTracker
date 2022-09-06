import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttracker/firebase_options.dart';
import 'package:ttracker/screens/wrapper.dart';
import 'package:ttracker/services/auth_provider.dart';
import 'package:wakelock/wakelock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Wakelock.enable();
  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
