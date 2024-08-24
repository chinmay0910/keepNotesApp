import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: [
          const Text("We've already send you verification Email. Please verify your Email ID"),
          const Text("If you have not received the Email then resend mail using following button"),
          TextButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              await user?.reload();

              await user?.sendEmailVerification();
            },
            child: const Text('Resend Mail'),
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (_) => false,
                );
              },
              child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
