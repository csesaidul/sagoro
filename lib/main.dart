import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sagoro/screens/chat_screen.dart';
import 'package:sagoro/screens/login_screen.dart';
import 'package:sagoro/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if Firebase is already initialized
    Firebase.app();
    print('Firebase already initialized');
  } catch (e) {
    // Only initialize if not already done
    await Firebase.initializeApp();
    print('Firebase initialized');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sagoro',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return user != null ? const ChatScreen() : const LoginScreen();
  }
}
