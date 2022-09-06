import 'package:flutter/material.dart';

class EmptyResultWidget extends StatelessWidget {
  final String message;

  final String title;
  const EmptyResultWidget({
    Key? key,
    this.title = 'Nothing here',
    this.message = 'Add a new item to get started',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 32, color: Colors.black54),
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
