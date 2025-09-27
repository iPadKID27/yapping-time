import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yappingtime/auth/auth_gate.dart';
import 'package:yappingtime/firebase_options.dart';
// import 'package:yappingtime/themes/light_mode.dart';
import 'package:yappingtime/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const AuthGate(),
        );
      },
    );
  }
}