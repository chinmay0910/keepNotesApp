import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';
import 'package:keepnotebook/services/auth/auth_exceptions.dart';
import 'package:keepnotebook/services/auth/auth_service.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'Enter your email here..'
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'Enter your password here..'
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try{
                final userCredential = await AuthService.firebase().logIn(
                    email: email,
                    password: password
                );
                // devtools.log(userCredential.toString());
                if(AuthService.firebase().currentUser?.isEmailVerified ?? false){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                        (_) => false,
                  );
                } else {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on UserNotFoundAuthException{
                showErrorDialog(context, 'User not found');
              } on WrongPasswordAuthException {
                showErrorDialog(context, 'Invalid Credentials');
              } on GenericAuthException {
                showErrorDialog(context, 'Authentication Error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                      (route) => false,
                );
              },
              child: const Text('Not Registered yet ? Register here!')
          )
        ],
      )
    );
  }
}