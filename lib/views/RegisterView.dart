import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';

import '../firebase_options.dart';

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
                        print(userCredential);
                      } on FirebaseAuthException catch (e){
                        if(e.code == 'weak-password'){
                          print('Make A Strong Password');
                        } else if(e.code == 'email-already-in-use'){
                          print("User Already Registered !! Signin Instead...");
                        } else if(e.code == 'invalid-email') {
                          print("Enter Correct EmailId !! (Incorrect Format)");
                        } else{
                          print(e.code);
                        }
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