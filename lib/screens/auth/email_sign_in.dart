import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ttracker/services/auth_provider.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  bool isSignIn = true;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthBase>(context);
    bool submitEnabled = _email.text.isNotEmpty & _password.text.isNotEmpty;
    final primaryText = isSignIn ? 'Sign in' : 'Sign up';
    final secondaryText = isSignIn ? 'Need an account ?' : 'Have an account ?';
    final thirdText = isSignIn ? 'Sign up' : 'Sign in';
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('TTracker'),
          centerTitle: true,
        ),
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
                                  ? await authService
                                      .signInWithEmailAndPassword(
                                          _email.text.trim(),
                                          _password.text.trim())
                                      .then((value) =>
                                          Navigator.of(context).pop())
                                  : await authService
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
