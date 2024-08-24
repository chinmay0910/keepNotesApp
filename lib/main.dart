import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';
import 'package:keepnotebook/services/auth/auth_service.dart';
import 'package:keepnotebook/views/LoginView.dart';
import 'package:keepnotebook/views/NotesView.dart';
import 'package:keepnotebook/views/RegisterView.dart';
import 'package:keepnotebook/views/verifyEmailView.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo 1',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegistrationView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  AuthService.firebase().initialize(),
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            devtools.log(user.toString());

            if(user != null){
              if(user.isEmailVerified){
                devtools.log('Email is Verified');
              }else {
                return const VerifyEmailView();
              }
            }else{
              return const LoginView();
            }
            return const NotesView();
          default:
            return const Scaffold(
                body: CircularProgressIndicator()
            );
        }
      },
    );
  }
}
