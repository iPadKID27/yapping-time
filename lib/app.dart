import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/views/auth/auth_gate_view.dart';

/// Root widget of the application
/// Wraps MaterialApp with theme provider and sets up initial route
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          // Remove debug banner
          debugShowCheckedModeBanner: false,
          
          // App title
          title: 'YappingTime',
          
          // Dynamic theme from ThemeProvider
          // Automatically updates when toggleTheme() is called
          theme: themeProvider.currentTheme,
          
          // Starting point - checks authentication status
          home: const AuthGateView(),
        );
      },
    );
  }
}