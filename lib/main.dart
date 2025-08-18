import 'package:flutter/material.dart';
import 'package:yappingtime/auth/loginOrRegister.dart';
import 'package:yappingtime/themes/lightMode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegisterPage(),
      theme: lightMode,
    );
  }
}


