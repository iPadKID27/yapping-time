import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yappingtime/auth/login_or_register.dart';
import 'package:yappingtime/pages/homa_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(); 
          } else {
            return LoginOrRegisterPage();
          }
        },
      )
    );
  }
}