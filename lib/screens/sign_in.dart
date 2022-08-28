import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:ttracker/screens/email_sign_in.dart';
import 'package:ttracker/services/auth_provider.dart';
import 'package:ttracker/widgets/social_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    ToastContext().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/logo.png',
              height: MediaQuery.of(context).size.height / 8,
            ),
            const Spacer(),
            const Text(
              'Sign in',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SocialButton(
                text: 'Sign in with Google',
                onPressed: () {
                  authService.signInWithGoogle();
                },
                backgroundColor: const Color(0xffDB4437)),
            const SizedBox(height: 10),
            SocialButton(
                text: 'Sign in with Facebook',
                onPressed: () {
                  authService.signInWithFacebook();
                },
                backgroundColor: const Color(0xff4267B2)),
            const SizedBox(height: 10),
            SocialButton(
                text: 'Sign in with Email',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => const EmailSignIn(),
                  ));
                },
                backgroundColor: Colors.teal),
            const SizedBox(height: 10),
            const Center(child: Text('Or', style: TextStyle(fontSize: 16))),
            const SizedBox(height: 10),
            SocialButton(
                text: 'Sign in Anonymously',
                onPressed: () {
                  authService.signInAnonymously();
                },
                backgroundColor: Colors.lime),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
