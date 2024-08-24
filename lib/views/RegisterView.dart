import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';
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
                        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: password
                        );
                        final user = await FirebaseAuth.instance.currentUser;
                        await user?.sendEmailVerification();
                        Navigator.of(context).pushNamed(
                            verifyEmailRoute
                        );
                      } on FirebaseAuthException catch (e){
                        if(e.code == 'weak-password'){
                          showErrorDialog(context,'Make A Strong Password');
                        } else if(e.code == 'email-already-in-use'){
                          showErrorDialog(context,"User Already Registered !! Signin Instead...");
                        } else if(e.code == 'invalid-email') {
                          showErrorDialog(context,"Enter Correct EmailId !! (Incorrect Format)");
                        } else{
                          showErrorDialog(context,'Error: ${e.code}');
                        }
                      } catch (e) {
                        showErrorDialog(context, 'Error: ${e.toString()}');
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
              );
            default:
              return Text('Loading..');
          }

        },
      ),
    );
  }
}