import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ttracker/firebase_options.dart';
import 'package:ttracker/screens/landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const LandingScreen(),
    );
  }
}
