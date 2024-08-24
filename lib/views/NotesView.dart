import 'package:flutter/material.dart';
import 'package:keepnotebook/services/auth/auth_service.dart';

import '../enum/MenuAction.dart';

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
                      await AuthService.firebase().logOut();
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