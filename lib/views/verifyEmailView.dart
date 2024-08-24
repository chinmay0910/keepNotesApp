import 'package:flutter/material.dart';
import 'package:keepnotebook/constants/routes.dart';
import 'package:keepnotebook/services/auth/auth_service.dart';

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
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Resend Mail'),
          ),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
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
