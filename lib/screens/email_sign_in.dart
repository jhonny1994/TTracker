import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ttracker/services/auth.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    bool submitEnabled = _email.text.isNotEmpty & _password.text.isNotEmpty;
    final primaryText = isSignIn ? 'Sign in' : 'Sign up';
    final secondaryText = isSignIn ? 'Need an account ?' : 'Have an account ?';
    final thirdText = isSignIn ? 'Sign up' : 'Sign in';
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        primaryText,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      onChanged: (value) => setState(() {}),
                      textInputAction: TextInputAction.next,
                      controller: _email,
                      enableSuggestions: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (value) => setState(() {}),
                      textInputAction: TextInputAction.done,
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: submitEnabled
                          ? () async {
                              context.loaderOverlay.show();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              !currentFocus.hasPrimaryFocus
                                  ? currentFocus.unfocus()
                                  : context.loaderOverlay.show();
                              isSignIn
                                  ? await Auth()
                                      .signInWithEmailAndPassword(
                                          _email.text.trim(),
                                          _password.text.trim())
                                      .then((value) =>
                                          Navigator.of(context).pop())
                                  : await Auth()
                                      .createUserWithEmailAndPassword(
                                          _email.text.trim(),
                                          _password.text.trim())
                                      .then((value) =>
                                          Navigator.of(context).pop());
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Text(primaryText),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(secondaryText),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _password.clear();
                                isSignIn = !isSignIn;
                              });
                            },
                            child: Text(thirdText)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
