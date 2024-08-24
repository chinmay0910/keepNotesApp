import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';
import 'package:keepnotebook/services/auth/auth_exceptions.dart';
import 'package:keepnotebook/services/auth/auth_service.dart';
import 'package:keepnotebook/utilities/show_error_dialog.dart';

import '../firebase_options.dart';

import 'dart:developer' as devtools show log;

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
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
        title: const Text('Register'),
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
                final userCredential = await AuthService.firebase().createUser(
                    email: email,
                    password: password
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                    verifyEmailRoute
                );
              } on WeakPasswordAuthException {
                showErrorDialog(context,'Make A Strong Password');
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(context,"User Already Registered !! Signin Instead...");
              } on InvalidEmailAuthException {
                showErrorDialog(context,"Enter Correct EmailId !! (Incorrect Format)");
              } on GenericAuthException {
                showErrorDialog(context,'Failed to Register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                      (route)=>false,
                );
              },
              child: Text('Already Registered ? Login here !')
          )
        ],
      ),
    );
  }
}