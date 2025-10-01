import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/chat/chat_bloc.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    // MultiProvider for Provider pattern (Theme & Navigation)
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => ChatService()),
      ],
      child: MultiBlocProvider(
        providers: [
          // BLoC for Authentication
          BlocProvider(
            create: (context) => AuthBloc(
              authService: context.read<AuthService>(),
            ),
          ),
          // BLoC for Chat functionality
          BlocProvider(
            create: (context) => ChatBloc(
              chatService: context.read<ChatService>(),
              authService: context.read<AuthService>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

