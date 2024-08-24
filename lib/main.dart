import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keepnotebook/constants/routes.dart';
import 'package:keepnotebook/views/LoginView.dart';
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
      future:  Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            devtools.log(user.toString());

            if(user != null){
              if(user.emailVerified){
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

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value){
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if(shouldLogout){
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/',
                        (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context){
              return [
                const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Logout'),
                ),
              ];
            }
          )
        ],
        backgroundColor: Colors.yellow,
      ),
      body: const Text('Verified user'),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out'),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: const Text('cancel')
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout')
            )
          ],
        );
      }
  ).then((value)=> value ?? false);
}