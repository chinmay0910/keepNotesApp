import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';
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
      body: FutureBuilder(
        future:  Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return Column(
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
                        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                            password: password
                        );
                        // devtools.log(userCredential.toString());
                        print(userCredential);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (_) => false,
                        );

                      } on FirebaseAuthException catch (e){
                        if(e.code == 'user-not-found'){
                          showErrorDialog(context, 'User not found');
                        } else if(e.code == 'invalid-credential'){
                          showErrorDialog(context, 'Invalid Credentials');
                        } else{
                          showErrorDialog(context, 'Error: ${e.code}');
                        }
                      } catch (e) {
                        showErrorDialog(context, e.toString());
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
              );
            default:
              return Text('Loading..');
          }

        },
      ),
    );
  }
}