import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String text;

  const SocialButton({
    Key? key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 15,
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(primary: backgroundColor, elevation: 4),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
