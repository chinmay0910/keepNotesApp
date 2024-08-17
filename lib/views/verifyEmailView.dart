import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Please verify your Email ID'),
        TextButton(
          onPressed: () async {
            User? user = FirebaseAuth.instance.currentUser;
            await user?.reload();

            await user?.sendEmailVerification();
          },
          child: const Text('Send Mail'),
        )
      ],
    );
  }
}
