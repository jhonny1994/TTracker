import 'package:flutter/material.dart';
import 'package:ttracker/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Auth().signOut();
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text('TTracker'),
        centerTitle: true,
      ),
    );
  }
}
